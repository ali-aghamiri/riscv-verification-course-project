module goldenmodel();    
    bit [31:0] instruction[1024:0];//instruction memory
    logic [31:0] data_memory[1024:0];//data memory
    bit [31:0] register [31:0];//register file
    int result_file;
    int clk;
    int counter;
    int inst_mem;
    bit [31:0] IR;
    string line;
    bit [31:0] temp;
    bit [31:0] pc;
    bit [31:0] main_pc;
    int rd;

initial begin
    for(int i=0; i<$size(data_memory); i++)begin
        data_memory[i]=32'h00000000;
    end
    for(int i = 0; i<$size(register); i++) begin
        register[i]=32'h00000000;
    end
    pc = 0;
    main_pc=0;
    IR=0;
    counter=0;
    
    //insert instruction from inst_mem to instruction array
    inst_mem=$fopen("file_data.txt","r");
    $readmemh("file_data.txt",instruction);
    $fclose(inst_mem);
    
    //write report of golden model
    result_file = $fopen("golden_result.txt","w");
    
    while (pc<$size(instruction)) begin
        IR = instruction[pc];
        $display("%h : %b ",instruction[pc],instruction[pc]);
        $fdisplay(result_file,"risc pc is :[%b] , result is [%b] , pc is [%b]",main_pc,register[rd],pc);
        if(IR[6:0] == 7'b0110011 || IR[6:0] == 7'b0111011)begin
            rd = rtype(IR);
        end
        else if(IR[6:0] == 7'b0000011 || IR[6:0] == 7'b0001111 || IR[6:0] == 7'b0010011||
                IR[6:0] == 7'b0011011 || IR[6:0] == 7'b1100111 || IR[6:0] == 7'b1110011)
                begin
            itype(IR);
        end
        else if(IR[6:0] == 7'b0100011)begin
            stype(IR);
        end
        else if(IR[6:0] == 7'b0010111 || IR[6:0] == 7'b0110111)begin
            utype(IR);
        end
        else if(IR[6:0] == 7'b1101111)begin
            jtype(IR);
        end
        else if(IR[6:0] == 7'b1100011)begin
           btype(IR);
        end else begin
            break;
        end   
    end

    $fclose(result_file);
end


//Functions : 
    function int rtype(bit[31:0] IR);
        bit[6:0] op;
        bit[4:0] rs1;
        bit[4:0] rs2;
        bit[4:0] rd;
        bit[2:0] func3;
        bit[6:0] func7;
        {func7,rs2,rs1,func3,rd,op}=IR;
        case (func7)
            7'b0000000 : begin
                case (func3)
                    3'b000 : //add
                        begin
                            register[rd] = register[rs1] + register[rs2];
                            pc=pc+1;
                            main_pc+=4;
                        end
                    3'b001 : //sll
                        begin 
                            $display("regd = %b, reg1 = %b, reg2 = %b",register[rd],register[rs1],register[rs2]);
                            register[rd] = register[rs1]<<register[rs2];
                            pc=pc+1;
                            main_pc+=4;
                        end
                    3'b010 : //slt
                        begin
                            register[rd] = (register[rs1]<<register[rs2]) ? 1:0;
                            pc=pc+1;
                            main_pc+=4;
                        end
                    3'b011 : //sltu
                        begin
                           register[rd] = unsigned'(unsigned'(register[rs1])<unsigned'(register[rs2])) ? 1:0;
                           pc=pc+1;
                           main_pc+=4;
                        end
                    3'b100 : //xor
                        begin
                            register[rd] = register[rs1] ^ register[rs2];
                            pc=pc+1;
                            main_pc+=4;
                        end
                    3'b101 : //srl
                        begin
                            register[rd] = register[rs1]>>register[rs2];
                            pc=pc+1;
                            main_pc+=4;
                        end
                    3'b110 : //or
                        begin
                            register[rd] = register[rs1] | register[rs2];   
                            pc=pc+1;
                            main_pc+=4;
                        end
                    3'b111 : //and
                        begin
                            register[rd] = register[rs1] & register[rs2];
                            pc=pc+1;
                            main_pc+=4;
                        end
                endcase
            end        

            7'b0100000 : begin
                case(func3)
                    3'b000 : //sub
                        begin
                            register[rd] = register[rs1] - register[rs2];
                            pc=pc+1;
                            main_pc+=4;
                        end
                    3'b101 : //sra
                        begin
                            register[rd] = register[rs1] >>> register[rs2];
                            pc=pc+1;
                            main_pc+=4;
                        end
                endcase
            end
        endcase
        return rd;
    endfunction

    function int itype(bit[31:0] IR);
        bit[6:0] op;
        bit[4:0] rs1;
        bit[4:0] rd;
        bit[2:0] func3;
        bit[11:0] imm;

        {imm,rs1,func3,rd,op}=IR;
        case (op)
            7'b0000011 : begin
                case (func3)
                    3'b000 : //lb
                    begin
                        temp = data_memory[register[rs1]+imm];
                        register[rd] = temp[7:0];
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b001 : //lh
                    begin
                        temp = data_memory[register[rs1]+imm];
                        register[rd] = temp[15:0];
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b010 : //lw
                    begin
                        register[rd] = data_memory[register[rs1]+imm];
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b011 : //ld
                    begin
                        //0-63?
                        register[rd] = data_memory[register[rs1]+imm];
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b100 : //lbu
                    begin
                        temp = data_memory[register[rs1]+imm];
                        register[rd] = unsigned'(temp[7:0]);
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b101 : //lhu
                    begin
                        temp = data_memory[register[rs1]+imm];
                        register[rd] = unsigned'(temp[15:0]);                    
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b110 : //lwu
                    begin
                        register[rd] = unsigned'(data_memory[register[rs1]+imm]);
                        pc=pc+1;
                        main_pc+=4;
                    end
                endcase
            end        
            7'b0010011 : begin
                case(func3)
                    3'b000 : //addi
                    begin
                        register[rd] = register[rs1] + imm;
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b001 : //slli
                    begin
                        register[rd] = register[rs1] <<imm;
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b010 : //slti
                    begin
                        register[rd] = (register[rs1]<imm)? 1:0;
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b011 : //sltiu
                    begin
                        register[rd] = (register[rs1]<unsigned'(imm));
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b100 : //xori
                    begin
                        register[rd] = register[rs1] ^ imm;
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b101 : //srli
                    begin
                        register[rd] = register[rs1] >> imm;
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b110 : //ori
                    begin
                        register[rd] = register[rs1] | imm;
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b111 : //andi
                    begin
                        register[rd] = register[rs1] & imm;
                        pc=pc+1;
                        main_pc+=4;
                    end
                endcase
            end
            7'b1100111 :begin
                //jalr
                register[rd] = pc+1;
                pc = register[rs1] + imm;
                main_pc = pc;        
                $display("pc : %b ",main_pc);
                $display("imm : %b ",imm);
                return pc;
            end
        endcase
        return rd;
    endfunction

    function void stype(bit[31:0] IR);
        bit[6:0] op;
        bit[4:0] rs1;
        bit[4:0] rs2;
        bit[2:0] func3;
        bit[11:0] imm;

        {imm[11:5],rs2,rs1,func3,imm[4:0],op}=IR;
        case (op)
            7'b0100011 : 
                case (func3)
                    3'b000 : //sb
                    begin
                        temp = register[rs2];
                        data_memory[register[rs1]+imm] = temp[8:0];
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b001 : //sh
                    begin
                        temp = register[rs2];
                        data_memory[register[rs1]+imm] = temp[15:0];
                        pc=pc+1;
                        main_pc+=4;
                    end
                    3'b010 : //sw
                    begin
                        temp = register[rs2];
                        data_memory[register[rs1]+imm] = temp[31:0];
                        pc=pc+1;
                        main_pc+=4;
                    end       
                    3'b011 : //sd
                    begin
                        //0-63?
                        temp = register[rs2];
                        data_memory[register[rs1]+imm] = temp[31:0];
                        pc=pc+1;
                        main_pc+=4;
                    end                    
                endcase
        endcase
    endfunction

    function int btype(bit[31:0] IR);
        bit[6:0] op;
        bit[4:0] rs1;
        bit[4:0] rs2;
        bit[2:0] func3;
        bit[11:0] imm;

        {imm[12],imm[10:5], rs2, rs1, func3, imm[4:1],imm[11], op} = IR;
        case (op)
            7'b1100011 : 
                case (func3)
                    3'b000 : //beq
                    begin
                        if(register[rs1]==register[rs2])
                            pc = pc +imm<<1;
                            main_pc=(main_pc + 4*imm);
                    end
                    3'b001 : //bne
                    begin
                        if(register[rs1]!=register[rs2])
                            pc = pc+imm<<1;
                            main_pc=(main_pc + 4*imm);

                    end
                    3'b100 : //blt
                    begin
                        if(register[rs1]<register[rs2])
                            pc = pc+imm<<1;
                            main_pc=(main_pc + 4*imm);

                    end
                    3'b101 : //bge
                    begin
                        if(register[rs1]>=register[rs2])
                            pc=pc+imm<<1;
                            main_pc=(main_pc + 4*imm);

                    end
                    3'b110 : //bltu
                    begin
                        if(register[rs1] < register[rs2])
                            pc=pc+unsigned'(imm)<<1;
                        main_pc=(main_pc + 4 * unsigned'(imm));
                    end
                    3'b111 : //bgeu
                    begin
                        if(register[rs1]>=register[rs2])
                            pc=pc+unsigned'(imm)<<1;
                        main_pc=(main_pc + 4 * unsigned'(imm));
                    end
                endcase
        endcase
        return main_pc;
    endfunction
     
    function int utype(bit[31:0] IR);
        bit[6:0] op;
        bit[4:0] rd;
        bit[19:0] imm;

        {imm,rd,op} = IR;
        case (op)
            7'b0010111 : //auipc  
            begin
                register[rd] = pc + imm<<12;
                pc=pc+1;
                main_pc+=4;
            end
            7'b0110111 : //lui
            begin
                register[rd] = imm<<12;
                pc=pc+1;
                main_pc+=4;
            end
        endcase
        return rd;
    endfunction
    
    function int jtype(bit[31:0] IR);
        bit[6:0] op;
        bit[4:0] rd;
        bit[19:0] imm;

        {imm,rd,op} = IR;
        case (op)
            7'b1101111 : //jal 
            begin
                register[rd]=pc+4;
                pc=pc+imm<<1;
                main_pc = (main_pc+4*imm);
            end 
        endcase
        return main_pc;
    endfunction
endmodule