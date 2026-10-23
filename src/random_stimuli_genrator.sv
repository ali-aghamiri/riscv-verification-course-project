module random_stimuli_genrator();
    integer file;

function void parser_R_Random(input integer rep);
begin

    //variables
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [6:0] opcode;
    reg [6:0] func7;
    reg [2:0] func3;
    reg [31:0] hex_code;
    
    repeat (rep) begin
    // Generate random R type instruction and register
    rd = $urandom_range(1, 18); // Random rd
    rs1 = $urandom_range(19, 36); // Random rs1
    rs2 = $urandom_range(37, 54); // Random rs2
    opcode = $urandom_range(1, 10);//Random Instruction
      
    case(opcode)//R-Type 
        1 : begin opcode = 7'h33; func3 = 3'h0; func7 = 7'h00;end//"add"
        2 : begin opcode = 7'h33; func3 = 3'h0; func7 = 7'h20;end//"sub"
        3 : begin opcode = 7'h33; func3 = 3'h1; func7 = 7'h00;end//"sll"
        4 : begin opcode = 7'h33; func3 = 3'h2; func7 = 7'h00;end//"slt"
        5 : begin opcode = 7'h33; func3 = 3'h3; func7 = 7'h00;end//"sltu"
        6 : begin opcode = 7'h33; func3 = 3'h4; func7 = 7'h00;end//"xor"
        7 : begin opcode = 7'h33; func3 = 3'h5; func7 = 7'h00;end//"srl"
        8 : begin opcode = 7'h33; func3 = 3'h5; func7 = 7'h20;end//"sra"
        9 : begin opcode = 7'h33; func3 = 3'h6; func7 = 7'h00;end//"or"
        10: begin opcode = 7'h33; func3 = 3'h7; func7 = 7'h00;end//"and"
        default : begin opcode = 7'h00; func3 = 3'h0; func7 = 7'h00;end
    endcase

    case(rd)
        //Saved
        1  : rd = 32'h00000009;//"x9"
        2  : rd = 32'h00000012;//"x18"
        3  : rd = 32'h00000013;//"x19"
        4  : rd = 32'h00000014;//"x20"
        5  : rd = 32'h00000015;//"x21"
        6  : rd = 32'h00000016;//"x22"
        7  : rd = 32'h00000017;//"x23"
        8  : rd = 32'h00000018;//"x24"
        9  : rd = 32'h00000019;//"x25"
        10 : rd = 32'h0000001A;//"x26"
        11 : rd = 32'h0000001B;//"x27"
        
        //Temporal 
        12 : rd = 32'h00000005;//"x5"
        13 : rd = 32'h00000006;//"x6"
        14 : rd = 32'h00000007;//"x7"
        15 : rd = 32'h0000001C;//"x28"
        16 : rd = 32'h0000001D;//"x29"
        17 : rd = 32'h0000001E;//"x30"
        18 : rd = 32'h0000001F;//"x31"
        default : rd = 32'h00000000;
    endcase

    case(rs1)
        //Saved
        19  : rs1 = 32'h00000009;//"x9"
        20  : rs1 = 32'h00000012;//"x18"
        21  : rs1 = 32'h00000013;//"x19"
        22  : rs1 = 32'h00000014;//"x20"
        23  : rs1 = 32'h00000015;//"x21"
        24  : rs1 = 32'h00000016;//"x22"
        25  : rs1 = 32'h00000017;//"x23"
        26  : rs1 = 32'h00000018;//"x24"
        27  : rs1 = 32'h00000019;//"x25"
        28 : rs1 = 32'h0000001A;//"x26"
        29 : rs1 = 32'h0000001B;//"x27"
        
        //Temporal 
        30 : rs1 = 32'h00000005;//"x5"
        31 : rs1 = 32'h00000006;//"x6"
        32 : rs1 = 32'h00000007;//"x7"
        33 : rs1 = 32'h0000001C;//"x28"
        34 : rs1 = 32'h0000001D;//"x29"
        35 : rs1 = 32'h0000001E;//"x30"
        36 : rs1 = 32'h0000001F;//"x31"
        default : rs1 = 32'h00000000;
    endcase

    case(rs2)
        //Saved
        37  : rs2 = 32'h00000009;//"x9"
        38  : rs2 = 32'h00000012;//"x18"
        39  : rs2 = 32'h00000013;//"x19"
        40  : rs2 = 32'h00000014;//"x20"
        41  : rs2 = 32'h00000015;//"x21"
        42  : rs2 = 32'h00000016;//"x22"
        43  : rs2 = 32'h00000017;//"x23"
        44  : rs2 = 32'h00000018;//"x24"
        45  : rs2 = 32'h00000019;//"x25"
        46 : rs2 = 32'h0000001A;//"x26"
        47 : rs2 = 32'h0000001B;//"x27"
        
        //Temporal 
        48 : rs2 = 32'h00000005;//"x5"
        49 : rs2 = 32'h00000006;//"x6"
        50 : rs2 = 32'h00000007;//"x7"
        51 : rs2 = 32'h0000001C;//"x28"
        52 : rs2 = 32'h0000001D;//"x29"
        53 : rs2 = 32'h0000001E;//"x30"
        54 : rs2 = 32'h0000001F;//"x31"
        default : rs2 = 32'h00000000;
    endcase

    hex_code = {func7, rs2, rs1, func3, rd, opcode};  
    $display("hex code is r: %h",hex_code);

    //Write in file
    $fdisplay(file, "%h", hex_code);
    end
end
endfunction

function void parser_I_Random(input integer rep);
begin

    //variables
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [6:0] opcode;
    reg [2:0] func3;
    reg [31:0] hex_code;
    int immediate;
    
    repeat (rep) begin
    // Generate random I type instruction and register
    rd = $urandom_range(1, 18); // Random rd
    rs1 = $urandom_range(19, 36); // Random rs1
    opcode = $urandom_range(1, 13);//Random Instruction
    immediate = $urandom_range(0, 255); 
    case(opcode)//I-Type      
        1 : begin opcode = 7'h03; func3 = 3'h1;end//"lb"
        2 : begin opcode = 7'h03; func3 = 3'h1;end//"lh"
        3 : begin opcode = 7'h03; func3 = 3'h2;end//"lw"
        4 : begin opcode = 7'h03; func3 = 3'h3;end//"ld"
        5 : begin opcode = 7'h03; func3 = 3'h4;end//"lbu"
        6 : begin opcode = 7'h03; func3 = 3'h5;end//"lhu"
        7 : begin opcode = 7'h03; func3 = 3'h6;end//"lwu"
        8: begin opcode = 7'h13; func3 = 3'h0;end//"addi"
        9: begin opcode = 7'h13; func3 = 3'h2;end//"slti"
        10: begin opcode = 7'h13; func3 = 3'h3;end//"sltiu"
        11: begin opcode = 7'h13; func3 = 3'h4;end//"xori"
        12: begin opcode = 7'h13; func3 = 3'h6;end//"ori"
        13: begin opcode = 7'h13; func3 = 3'h7;end//"andi"
        //14: begin opcode = 7'h67; func3 = 3'h0;end//"jalr"
        default : begin opcode = 7'h00; func3 = 3'h0;end
    endcase

    case(rd)
        //Saved
        1  : rd = 32'h00000009;//"x9"
        2  : rd = 32'h00000012;//"x18"
        3  : rd = 32'h00000013;//"x19"
        4  : rd = 32'h00000014;//"x20"
        5  : rd = 32'h00000015;//"x21"
        6  : rd = 32'h00000016;//"x22"
        7  : rd = 32'h00000017;//"x23"
        8  : rd = 32'h00000018;//"x24"
        9  : rd = 32'h00000019;//"x25"
        10 : rd = 32'h0000001A;//"x26"
        11 : rd = 32'h0000001B;//"x27"
        
        //Temporal 
        12 : rd = 32'h00000005;//"x5"
        13 : rd = 32'h00000006;//"x6"
        14 : rd = 32'h00000007;//"x7"
        15 : rd = 32'h0000001C;//"x28"
        16 : rd = 32'h0000001D;//"x29"
        17 : rd = 32'h0000001E;//"x30"
        18 : rd = 32'h0000001F;//"x31"
        default : rd = 32'h00000000;
    endcase

    case(rs1)
        //Saved
        19  : rs1 = 32'h00000009;//"x9"
        20  : rs1 = 32'h00000012;//"x18"
        21  : rs1 = 32'h00000013;//"x19"
        22  : rs1 = 32'h00000014;//"x20"
        23  : rs1 = 32'h00000015;//"x21"
        24  : rs1 = 32'h00000016;//"x22"
        25  : rs1 = 32'h00000017;//"x23"
        26  : rs1 = 32'h00000018;//"x24"
        27  : rs1 = 32'h00000019;//"x25"
        28  : rs1 = 32'h0000001A;//"x26"
        29  : rs1 = 32'h0000001B;//"x27"
        
        //Temporal 
        30 : rs1 = 32'h00000005;//"x5"
        31 : rs1 = 32'h00000006;//"x6"
        32 : rs1 = 32'h00000007;//"x7"
        33 : rs1 = 32'h0000001C;//"x28"
        34 : rs1 = 32'h0000001D;//"x29"
        35 : rs1 = 32'h0000001E;//"x30"
        36 : rs1 = 32'h0000001F;//"x31"
        default : rs1 = 32'h00000000;
    endcase


    hex_code = {immediate[11:0], rs1, func3, rd, opcode};   
    $display("hex code is i : %h",hex_code);

    //Write in file
    $fdisplay(file, "%h", hex_code);
    end
end
endfunction

function void parser_S_Random(input integer rep);
begin
    //variables
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [6:0] opcode;
    reg [6:0] func7;
    reg [2:0] func3;
    reg [31:0] hex_code;
    integer immediate;

    repeat (rep) begin
    // Generate random I type instruction and register
    rd = $urandom_range(1, 18); // Random rd
    rs1 = $urandom_range(19, 36); // Random rs1
    rs2 = $urandom_range(37, 54); // Random rs2
    opcode = $urandom_range(1, 4);//Random Instruction
    immediate = $urandom_range(0, 255); 

    case(opcode)//S-Type
        1 :begin opcode = 7'h23; func3 = 3'h0;end//"sb"
        2 : begin opcode = 7'h23; func3 = 3'h1; end//"sh"
        3 : begin opcode = 7'h23; func3 = 3'h2; end//"sw"
        4 : begin opcode = 7'h23; func3 = 3'h3; end//"sd"
        default : begin opcode = 7'h00; func3 = 3'h0; end
    endcase

    case(rd)
        //Saved
        1  : rd = 32'h00000009;//"x9"
        2  : rd = 32'h00000012;//"x18"
        3  : rd = 32'h00000013;//"x19"
        4  : rd = 32'h00000014;//"x20"
        5  : rd = 32'h00000015;//"x21"
        6  : rd = 32'h00000016;//"x22"
        7  : rd = 32'h00000017;//"x23"
        8  : rd = 32'h00000018;//"x24"
        9  : rd = 32'h00000019;//"x25"
        10 : rd = 32'h0000001A;//"x26"
        11 : rd = 32'h0000001B;//"x27"
        
        //Temporal 
        12 : rd = 32'h00000005;//"x5"
        13 : rd = 32'h00000006;//"x6"
        14 : rd = 32'h00000007;//"x7"
        15 : rd = 32'h0000001C;//"x28"
        16 : rd = 32'h0000001D;//"x29"
        17 : rd = 32'h0000001E;//"x30"
        18 : rd = 32'h0000001F;//"x31"
        default : rd = 32'h00000000;
    endcase

    case(rs1)
        //Saved
        19  : rs1 = 32'h00000009;//"x9"
        20  : rs1 = 32'h00000012;//"x18"
        21  : rs1 = 32'h00000013;//"x19"
        22  : rs1 = 32'h00000014;//"x20"
        23  : rs1 = 32'h00000015;//"x21"
        24  : rs1 = 32'h00000016;//"x22"
        25  : rs1 = 32'h00000017;//"x23"
        26  : rs1 = 32'h00000018;//"x24"
        27  : rs1 = 32'h00000019;//"x25"
        28 : rs1 = 32'h0000001A;//"x26"
        29 : rs1 = 32'h0000001B;//"x27"
        
        //Temporal 
        30 : rs1 = 32'h00000005;//"x5"
        31 : rs1 = 32'h00000006;//"x6"
        32 : rs1 = 32'h00000007;//"x7"
        33 : rs1 = 32'h0000001C;//"x28"
        34 : rs1 = 32'h0000001D;//"x29"
        35 : rs1 = 32'h0000001E;//"x30"
        36 : rs1 = 32'h0000001F;//"x31"
        default : rs1 = 32'h00000000;
    endcase

    case(rs2)
        //Saved
        37  : rs2 = 32'h00000009;//"x9"
        38  : rs2 = 32'h00000012;//"x18"
        39  : rs2 = 32'h00000013;//"x19"
        40  : rs2 = 32'h00000014;//"x20"
        41  : rs2 = 32'h00000015;//"x21"
        42  : rs2 = 32'h00000016;//"x22"
        43  : rs2 = 32'h00000017;//"x23"
        44  : rs2 = 32'h00000018;//"x24"
        45  : rs2 = 32'h00000019;//"x25"
        46 : rs2 = 32'h0000001A;//"x26"
        47 : rs2 = 32'h0000001B;//"x27"
        
        //Temporal 
        48 : rs2 = 32'h00000005;//"x5"
        49 : rs2 = 32'h00000006;//"x6"
        50 : rs2 = 32'h00000007;//"x7"
        51 : rs2 = 32'h0000001C;//"x28"
        52 : rs2 = 32'h0000001D;//"x29"
        53 : rs2 = 32'h0000001E;//"x30"
        54 : rs2 = 32'h0000001F;//"x31"
        default : rs2 = 32'h00000000;
    endcase
    $display("immediate is %h , rs1 = %h, rs2=%h , func3 = %h, opcode = %h",immediate,rs1,rs2,func3,opcode);
    hex_code = {immediate[11:5], rs2, rs1, func3,immediate[4:0], opcode};   
    $display("hex code is s: %h",hex_code);

    //Write in file
    $fdisplay(file, "%h", hex_code);
    end
end
endfunction

function void parser_J_Random(input integer rep);
begin

    //variables
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [6:0] opcode;
    reg [6:0] func7;
    reg [2:0] func3;
    reg [31:0] hex_code;
    integer immediate;

    repeat (rep) begin
    // Generate random I type instruction and register
    rd = $urandom_range(1, 18); // Random rd
    rs1 = $urandom_range(19, 36); // Random rs1
    rs2 = $urandom_range(37, 54); // Random rs2
    opcode = 1;
        immediate = $urandom_range(0, 255); 

  

    case(opcode)//J-Type:
        1 : opcode = 7'h6F;//"jal"
        default : opcode = 7'h00;      
    endcase

    case(rd)
        //Saved
        1  : rd = 32'h00000009;//"x9"
        2  : rd = 32'h00000012;//"x18"
        3  : rd = 32'h00000013;//"x19"
        4  : rd = 32'h00000014;//"x20"
        5  : rd = 32'h00000015;//"x21"
        6  : rd = 32'h00000016;//"x22"
        7  : rd = 32'h00000017;//"x23"
        8  : rd = 32'h00000018;//"x24"
        9  : rd = 32'h00000019;//"x25"
        10 : rd = 32'h0000001A;//"x26"
        11 : rd = 32'h0000001B;//"x27"
        
        //Temporal 
        12 : rd = 32'h00000005;//"x5"
        13 : rd = 32'h00000006;//"x6"
        14 : rd = 32'h00000007;//"x7"
        15 : rd = 32'h0000001C;//"x28"
        16 : rd = 32'h0000001D;//"x29"
        17 : rd = 32'h0000001E;//"x30"
        18 : rd = 32'h0000001F;//"x31"
        default : rd = 32'h00000000;
    endcase

    case(rs1)
        //Saved
        19  : rs1 = 32'h00000009;//"x9"
        20  : rs1 = 32'h00000012;//"x18"
        21  : rs1 = 32'h00000013;//"x19"
        22  : rs1 = 32'h00000014;//"x20"
        23  : rs1 = 32'h00000015;//"x21"
        24  : rs1 = 32'h00000016;//"x22"
        25  : rs1 = 32'h00000017;//"x23"
        26  : rs1 = 32'h00000018;//"x24"
        27  : rs1 = 32'h00000019;//"x25"
        28 : rs1 = 32'h0000001A;//"x26"
        29 : rs1 = 32'h0000001B;//"x27"
        
        //Temporal 
        30 : rs1 = 32'h00000005;//"x5"
        31 : rs1 = 32'h00000006;//"x6"
        32 : rs1 = 32'h00000007;//"x7"
        33 : rs1 = 32'h0000001C;//"x28"
        34 : rs1 = 32'h0000001D;//"x29"
        35 : rs1 = 32'h0000001E;//"x30"
        36 : rs1 = 32'h0000001F;//"x31"
        default : rs1 = 32'h00000000;
    endcase

    case(rs2)
        //Saved
        37  : rs2 = 32'h00000009;//"x9"
        38  : rs2 = 32'h00000012;//"x18"
        39  : rs2 = 32'h00000013;//"x19"
        40  : rs2 = 32'h00000014;//"x20"
        41  : rs2 = 32'h00000015;//"x21"
        42  : rs2 = 32'h00000016;//"x22"
        43  : rs2 = 32'h00000017;//"x23"
        44  : rs2 = 32'h00000018;//"x24"
        45  : rs2 = 32'h00000019;//"x25"
        46 : rs2 = 32'h0000001A;//"x26"
        47 : rs2 = 32'h0000001B;//"x27"
        
        //Temporal 
        48 : rs2 = 32'h00000005;//"x5"
        49 : rs2 = 32'h00000006;//"x6"
        50 : rs2 = 32'h00000007;//"x7"
        51 : rs2 = 32'h0000001C;//"x28"
        52 : rs2 = 32'h0000001D;//"x29"
        53 : rs2 = 32'h0000001E;//"x30"
        54 : rs2 = 32'h0000001F;//"x31"
        default : rs2 = 32'h00000000;
    endcase

    immediate = immediate <<1;

    hex_code = { immediate[20],immediate[10:1],immediate[11],immediate[19:12],rd, opcode};  
    $display("hex code is j : %h",hex_code);

    //Write in file
    $fdisplay(file, "%h", hex_code);
    end
end
endfunction

function void parser_U_Random(input integer rep);
begin

    //variables
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [6:0] opcode;
    reg [6:0] func7;
    reg [2:0] func3;
    reg [31:0] hex_code;
    integer immediate;

    repeat (rep) begin
    // Generate random I type instruction and register
    rd = $urandom_range(1, 18); // Random rd
    rs1 = $urandom_range(19, 36); // Random rs1
    rs2 = $urandom_range(37, 54); // Random rs2
    opcode = $urandom_range(1, 2);// Random instruction
    immediate = $urandom_range(0, 255); 
  

    case(opcode)//U-Type
        1 : opcode = 7'h37;//"lui"
        2 : opcode = 7'h17;//"auipc"
    endcase

    case(rd)
        //Saved
        1  : rd = 32'h00000009;//"x9"
        2  : rd = 32'h00000012;//"x18"
        3  : rd = 32'h00000013;//"x19"
        4  : rd = 32'h00000014;//"x20"
        5  : rd = 32'h00000015;//"x21"
        6  : rd = 32'h00000016;//"x22"
        7  : rd = 32'h00000017;//"x23"
        8  : rd = 32'h00000018;//"x24"
        9  : rd = 32'h00000019;//"x25"
        10 : rd = 32'h0000001A;//"x26"
        11 : rd = 32'h0000001B;//"x27"
        
        //Temporal 
        12 : rd = 32'h00000005;//"x5"
        13 : rd = 32'h00000006;//"x6"
        14 : rd = 32'h00000007;//"x7"
        15 : rd = 32'h0000001C;//"x28"
        16 : rd = 32'h0000001D;//"x29"
        17 : rd = 32'h0000001E;//"x30"
        18 : rd = 32'h0000001F;//"x31"
        default : rd = 32'h00000000;
    endcase

    case(rs1)
        //Saved
        19  : rs1 = 32'h00000009;//"x9"
        20  : rs1 = 32'h00000012;//"x18"
        21  : rs1 = 32'h00000013;//"x19"
        22  : rs1 = 32'h00000014;//"x20"
        23  : rs1 = 32'h00000015;//"x21"
        24  : rs1 = 32'h00000016;//"x22"
        25  : rs1 = 32'h00000017;//"x23"
        26  : rs1 = 32'h00000018;//"x24"
        27  : rs1 = 32'h00000019;//"x25"
        28 : rs1 = 32'h0000001A;//"x26"
        29 : rs1 = 32'h0000001B;//"x27"
        
        //Temporal 
        30 : rs1 = 32'h00000005;//"x5"
        31 : rs1 = 32'h00000006;//"x6"
        32 : rs1 = 32'h00000007;//"x7"
        33 : rs1 = 32'h0000001C;//"x28"
        34 : rs1 = 32'h0000001D;//"x29"
        35 : rs1 = 32'h0000001E;//"x30"
        36 : rs1 = 32'h0000001F;//"x31"
        default : rs1 = 32'h00000000;
    endcase

    case(rs2)
        //Saved
        37  : rs2 = 32'h00000009;//"x9"
        38  : rs2 = 32'h00000012;//"x18"
        39  : rs2 = 32'h00000013;//"x19"
        40  : rs2 = 32'h00000014;//"x20"
        41  : rs2 = 32'h00000015;//"x21"
        42  : rs2 = 32'h00000016;//"x22"
        43  : rs2 = 32'h00000017;//"x23"
        44  : rs2 = 32'h00000018;//"x24"
        45  : rs2 = 32'h00000019;//"x25"
        46 : rs2 = 32'h0000001A;//"x26"
        47 : rs2 = 32'h0000001B;//"x27"
        
        //Temporal 
        48 : rs2 = 32'h00000005;//"x5"
        49 : rs2 = 32'h00000006;//"x6"
        50 : rs2 = 32'h00000007;//"x7"
        51 : rs2 = 32'h0000001C;//"x28"
        52 : rs2 = 32'h0000001D;//"x29"
        53 : rs2 = 32'h0000001E;//"x30"
        54 : rs2 = 32'h0000001F;//"x31"
        default : rs2 = 32'h00000000;
    endcase

    immediate = immediate << 12;
    hex_code = {immediate[31:12], rd, opcode};
    
    $display("hex code is u : %h",hex_code);

    //Write in file
    $fdisplay(file, "%h", hex_code);
    end
end
endfunction

function void parser_B_Random(input integer rep);
begin

    //variables
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [4:0] rd;
    reg [6:0] opcode;
    reg [6:0] func7;
    reg [2:0] func3;
    reg [31:0] hex_code;
    integer immediate;

    repeat (rep) begin
    // Generate random I type instruction and register
    rd = $urandom_range(1, 18); // Random rd
    rs1 = $urandom_range(19, 36); // Random rs1
    rs2 = $urandom_range(37, 54); // Random rs2
    opcode = $urandom_range(1, 6);// Random instruction
    immediate = $urandom_range(0, 4095);  
  

    case(opcode)//B-Type
        1 :begin opcode = 7'h63; func3 = 3'h0;end//"beq"
        2 :begin opcode = 7'h63; func3 = 3'h1;end//"bne"
        3 :begin opcode = 7'h63; func3 = 3'h4;end//"blt"
        4 :begin opcode = 7'h63; func3 = 3'h5;end//"bge"
        5 :begin opcode = 7'h63; func3 = 3'h6;end//"bltu"
        6 :begin opcode = 7'h63; func3 = 3'h7;end//"bgeu"
        default:begin opcode = 7'h00; func3 = 3'h0;end
    endcase

    case(rd)
        //Saved
        1  : rd = 32'h00000009;//"x9"
        2  : rd = 32'h00000012;//"x18"
        3  : rd = 32'h00000013;//"x19"
        4  : rd = 32'h00000014;//"x20"
        5  : rd = 32'h00000015;//"x21"
        6  : rd = 32'h00000016;//"x22"
        7  : rd = 32'h00000017;//"x23"
        8  : rd = 32'h00000018;//"x24"
        9  : rd = 32'h00000019;//"x25"
        10 : rd = 32'h0000001A;//"x26"
        11 : rd = 32'h0000001B;//"x27"
        
        //Temporal 
        12 : rd = 32'h00000005;//"x5"
        13 : rd = 32'h00000006;//"x6"
        14 : rd = 32'h00000007;//"x7"
        15 : rd = 32'h0000001C;//"x28"
        16 : rd = 32'h0000001D;//"x29"
        17 : rd = 32'h0000001E;//"x30"
        18 : rd = 32'h0000001F;//"x31"
        default : rd = 32'h00000000;
    endcase

    case(rs1)
        //Saved
        19  : rs1 = 32'h00000009;//"x9"
        20  : rs1 = 32'h00000012;//"x18"
        21  : rs1 = 32'h00000013;//"x19"
        22  : rs1 = 32'h00000014;//"x20"
        23  : rs1 = 32'h00000015;//"x21"
        24  : rs1 = 32'h00000016;//"x22"
        25  : rs1 = 32'h00000017;//"x23"
        26  : rs1 = 32'h00000018;//"x24"
        27  : rs1 = 32'h00000019;//"x25"
        28 : rs1 = 32'h0000001A;//"x26"
        29 : rs1 = 32'h0000001B;//"x27"
        
        //Temporal 
        30 : rs1 = 32'h00000005;//"x5"
        31 : rs1 = 32'h00000006;//"x6"
        32 : rs1 = 32'h00000007;//"x7"
        33 : rs1 = 32'h0000001C;//"x28"
        34 : rs1 = 32'h0000001D;//"x29"
        35 : rs1 = 32'h0000001E;//"x30"
        36 : rs1 = 32'h0000001F;//"x31"
        default : rs1 = 32'h00000000;
    endcase

    case(rs2)
        //Saved
        37  : rs2 = 32'h00000009;//"x9"
        38  : rs2 = 32'h00000012;//"x18"
        39  : rs2 = 32'h00000013;//"x19"
        40  : rs2 = 32'h00000014;//"x20"
        41  : rs2 = 32'h00000015;//"x21"
        42  : rs2 = 32'h00000016;//"x22"
        43  : rs2 = 32'h00000017;//"x23"
        44  : rs2 = 32'h00000018;//"x24"
        45  : rs2 = 32'h00000019;//"x25"
        46 : rs2 = 32'h0000001A;//"x26"
        47 : rs2 = 32'h0000001B;//"x27"
        
        //Temporal 
        48 : rs2 = 32'h00000005;//"x5"
        49 : rs2 = 32'h00000006;//"x6"
        50 : rs2 = 32'h00000007;//"x7"
        51 : rs2 = 32'h0000001C;//"x28"
        52 : rs2 = 32'h0000001D;//"x29"
        53 : rs2 = 32'h0000001E;//"x30"
        54 : rs2 = 32'h0000001F;//"x31"
        default : rs2 = 32'h00000000;
    endcase

    immediate = immediate <<1;
    hex_code = {immediate[12],immediate[10:5], rs2, rs1, func3, immediate[4:1],immediate[11], opcode};      
    $display("hex code is b : %h",hex_code);

    //Write in file
    $fdisplay(file, "%h", hex_code);
    end
end
endfunction

initial begin
    //Open file
    file = $fopen("file_data.txt", "w");

     parser_R_Random(1000);
     parser_I_Random(1000);
     parser_S_Random(1000);
     parser_U_Random(1000);
     parser_B_Random(10);
     parser_J_Random(10);

    //Close file
    $fclose(file);
end

endmodule