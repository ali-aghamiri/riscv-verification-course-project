`timescale 1ns/1ps

// Self-checking harness for the attributed third-party pipelined RV32I core.
module tb_scoreboard;
    localparam logic [31:0] TEXT_BASE = 32'h00400000;
    localparam logic [31:0] DATA_BASE = 32'h80000000;

    logic clock = 0;
    logic reset = 1;
    wire [31:0] pc;
    wire [31:0] inst;
    wire [31:0] bus_address;
    wire [31:0] bus_read_data;
    wire [31:0] bus_write_data;
    wire [3:0] bus_byte_enable;
    wire bus_read_enable;
    wire bus_write_enable;
    logic [31:0] instruction_rom [0:255];
    logic [31:0] data_memory [0:255];
    logic [63:0] expected [0:127];
    logic [31:0] expected_memory [0:255];
    string program_path;
    string expected_path;
    string memory_path;
    integer program_words;
    integer expected_writes;
    integer sentinel;
    integer observed = 0;
    integer index;
    integer lane;
    integer word_index;

    always #5 clock = ~clock;

    assign inst = (pc >= TEXT_BASE && pc < TEXT_BASE + program_words * 4)
                ? instruction_rom[(pc - TEXT_BASE) >> 2] : 32'h00000013;
    assign bus_read_data = bus_read_enable && bus_address >= DATA_BASE
                        && bus_address < DATA_BASE + 1024
                        ? data_memory[(bus_address - DATA_BASE) >> 2] : 32'b0;

    riscv_core dut (
        .clock(clock), .reset(reset),
        .bus_address(bus_address), .bus_read_data(bus_read_data),
        .bus_write_data(bus_write_data), .bus_byte_enable(bus_byte_enable),
        .bus_read_enable(bus_read_enable), .bus_write_enable(bus_write_enable),
        .inst(inst), .pc(pc)
    );

    always @(posedge clock) begin
        if (!reset && bus_write_enable) begin
            if (bus_address < DATA_BASE || bus_address >= DATA_BASE + 1024)
                $fatal(1, "Store outside data memory: %h", bus_address);
            word_index = (bus_address - DATA_BASE) >> 2;
            for (lane = 0; lane < 4; lane = lane + 1)
                if (bus_byte_enable[lane])
                    data_memory[word_index][8*lane +: 8] <= bus_write_data[8*lane +: 8];
        end
        if (!reset && dut.pipeline_datapath.regfile_write_enable[4]
                   && dut.pipeline_datapath.inst_rd[4] != 0) begin
            if (observed >= expected_writes)
                $fatal(1, "Unexpected extra writeback: rd=%0d value=%h",
                       dut.pipeline_datapath.inst_rd[4], dut.pipeline_datapath.rd_data[4]);
            if ({27'b0, dut.pipeline_datapath.inst_rd[4], dut.pipeline_datapath.rd_data[4]}
                !== expected[observed])
                $fatal(1, "Writeback %0d: expected %h, got rd=%0d value=%h",
                       observed, expected[observed], dut.pipeline_datapath.inst_rd[4],
                       dut.pipeline_datapath.rd_data[4]);
            observed = observed + 1;
        end
    end

    initial begin
        for (index = 0; index < 256; index = index + 1) begin
            instruction_rom[index] = 32'h00000013;
            data_memory[index] = 0;
        end
        if (!$value$plusargs("program=%s", program_path))
            $fatal(1, "Supply +program=path");
        if (!$value$plusargs("expected=%s", expected_path))
            $fatal(1, "Supply +expected=path");
        if (!$value$plusargs("memory=%s", memory_path))
            $fatal(1, "Supply +memory=path");
        if (!$value$plusargs("word_count=%d", program_words))
            $fatal(1, "Supply +word_count=N");
        if (!$value$plusargs("write_count=%d", expected_writes))
            $fatal(1, "Supply +write_count=N");
        if (!$value$plusargs("sentinel=%d", sentinel))
            $fatal(1, "Supply +sentinel=N");
        $readmemh(program_path, instruction_rom);
        $readmemh(expected_path, expected);
        $readmemh(memory_path, expected_memory);
        repeat (3) @(negedge clock);
        reset = 0;
        wait (data_memory[1] == sentinel);
        repeat (8) @(negedge clock);
        if (observed != expected_writes)
            $fatal(1, "Missing writebacks: expected %0d, got %0d", expected_writes, observed);
        for (index = 0; index < 256; index = index + 1)
            if (data_memory[index] !== expected_memory[index])
                $fatal(1, "Data memory word %0d: expected %h, got %h",
                       index, expected_memory[index], data_memory[index]);
        $display("PASS: %0d writebacks, control flow, data memory", observed);
        $finish;
    end

    initial begin
        #10000;
        $fatal(1, "Timeout before completion store");
    end
endmodule
