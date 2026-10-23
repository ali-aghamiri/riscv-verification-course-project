module determenstic_stimuli_genrator();
    integer file;

function void parser_R(input string operation,input int reg_d,input int reg_s1,input int reg_s2);
begin
    //variables
        reg [4:0] rs1;
        reg [4:0] rs2;
        reg [4:0] rd;
        reg [6:0] opcode;
        reg [6:0] func7;
        reg [2:0] func3;
        reg [31:0] hex_code;

    case(operation)//R-Type 
        "add" :begin opcode = 7'h33; func3 = 3'h0; func7 = 7'h00;end
        "sub" : begin opcode = 7'h33; func3 = 3'h0; func7 = 7'h20;end
        "sll" :begin opcode = 7'h33; func3 = 3'h1; func7 = 7'h00;end
        "slt" :begin opcode = 7'h33; func3 = 3'h2; func7 = 7'h00;end
        "sltu" :begin opcode = 7'h33; func3 = 3'h3; func7 = 7'h00;end
        "xor" :begin opcode = 7'h33; func3 = 3'h4; func7 = 7'h00;end
        "srl" :begin opcode = 7'h33; func3 = 3'h5; func7 = 7'h00;end
        "sra" :begin opcode = 7'h33; func3 = 3'h5; func7 = 7'h20;end
        "or" :begin opcode = 7'h33; func3 = 3'h6; func7 = 7'h00;end
        "and" :begin opcode = 7'h33; func3 = 3'h7; func7 = 7'h00;end
        default : begin opcode = 7'h00; func3 = 3'h0; func7 = 7'h00;end
    endcase
    case(reg_d)
        //Saved
        9  : rd = 32'h00000009;
        18 : rd = 32'h00000012;
        19 : rd = 32'h00000013;
        20 : rd = 32'h00000014;
        21 : rd = 32'h00000015;
        22 : rd = 32'h00000016;
        23 : rd = 32'h00000017;
        24 : rd = 32'h00000018;
        25 : rd = 32'h00000019;
        26 : rd = 32'h0000001A;
        27 : rd = 32'h0000001B;
        
        //Temporal 
        5  : rd = 32'h00000005;
        6  : rd = 32'h00000006;
        7  : rd = 32'h00000007;
        28 : rd = 32'h0000001C;
        29 : rd = 32'h0000001D;
        30 : rd = 32'h0000001E;
        31 : rd = 32'h0000001F;
        default : rd = 32'h00000000;
    endcase
    case(reg_s1)
        //Saved
        //Saved
        9  : rs1 = 32'h00000009;
        18 : rs1 = 32'h00000012;
        19 : rs1 = 32'h00000013;
        20 : rs1 = 32'h00000014;
        21 : rs1 = 32'h00000015;
        22 : rs1 = 32'h00000016;
        23 : rs1 = 32'h00000017;
        24 : rs1 = 32'h00000018;
        25 : rs1 = 32'h00000019;
        26 : rs1 = 32'h0000001A;
        27 : rs1 = 32'h0000001B;
        
        //Temporal 
        5  : rs1 = 32'h00000005;
        6  : rs1 = 32'h00000006;
        7  : rs1 = 32'h00000007;
        28 : rs1 = 32'h0000001C;
        29 : rs1 = 32'h0000001D;
        30 : rs1 = 32'h0000001E;
        31 : rs1 = 32'h0000001F;
        default : rs1 = 32'h00000000;
    endcase
    case(reg_s2)
        //Saved
        //Saved
        9  : rs2 = 32'h00000009;
        18 : rs2 = 32'h00000012;
        19 : rs2 = 32'h00000013;
        20 : rs2 = 32'h00000014;
        21 : rs2 = 32'h00000015;
        22 : rs2 = 32'h00000016;
        23 : rs2 = 32'h00000017;
        24 : rs2 = 32'h00000018;
        25 : rs2 = 32'h00000019;
        26 : rs2 = 32'h0000001A;
        27 : rs2 = 32'h0000001B;
        
        //Temporal 
        5  : rs2 = 32'h00000005;
        6  : rs2 = 32'h00000006;
        7  : rs2 = 32'h00000007;
        28 : rs2 = 32'h0000001C;
        29 : rs2 = 32'h0000001D;
        30 : rs2 = 32'h0000001E;
        31 : rs2 = 32'h0000001F;
        default : rs2 = 32'h00000000;
    endcase

    hex_code = {func7, rs2, rs1, func3, rd, opcode};   

    $display("hex code is : %h",hex_code);
  
    //Write in file
    $fdisplay(file, "%h", hex_code);
end
endfunction

function void parser_I(input string operation,input int reg_d,input int reg_s1,input integer immediate);
begin

    //variables
    reg [4:0] rs1;
    reg [4:0] rd;
    reg [6:0] opcode;
    reg [6:0] func7;
    reg [2:0] func3;
    reg [31:0] hex_code;    

    case(operation)//I-Type      
        "lb" : begin opcode = 7'h03; func3 = 3'h1;end
        "lh" : begin opcode = 7'h03; func3 = 3'h1;end
        "lw" : begin opcode = 7'h03; func3 = 3'h2;end
        "ld" : begin opcode = 7'h03; func3 = 3'h3;end
        "lbu" : begin opcode = 7'h03; func3 = 3'h4;end
        "lhu" : begin opcode = 7'h03; func3 = 3'h5;end
        "lwu" : begin opcode = 7'h03; func3 = 3'h6;end
        "fence" : begin opcode = 7'h0f; func3 = 3'h0;end
        "fence.i" : begin opcode = 7'h0f; func3 = 3'h1;end
        "addi" : begin opcode = 7'h13; func3 = 3'h0;end
        "slti" : begin opcode = 7'h13; func3 = 3'h2;end
        "sltiu" : begin opcode = 7'h13; func3 = 3'h3;end
        "xori" : begin opcode = 7'h13; func3 = 3'h4;end
        "ori" : begin opcode = 7'h13; func3 = 3'h6;end
        "andi" : begin opcode = 7'h13; func3 = 3'h7;end
        "jalr" : begin opcode = 7'h67; func3 = 3'h0;end
        default : begin opcode = 7'h00; func3 = 3'h0;end
    endcase

    case(reg_d)
        //Saved
        9  : rd = 32'h00000009;
        18 : rd = 32'h00000012;
        19 : rd = 32'h00000013;
        20 : rd = 32'h00000014;
        21 : rd = 32'h00000015;
        22 : rd = 32'h00000016;
        23 : rd = 32'h00000017;
        24 : rd = 32'h00000018;
        25 : rd = 32'h00000019;
        26 : rd = 32'h0000001A;
        27 : rd = 32'h0000001B;
        
        //Temporal 
        5  : rd = 32'h00000005;
        6  : rd = 32'h00000006;
        7  : rd = 32'h00000007;
        28 : rd = 32'h0000001C;
        29 : rd = 32'h0000001D;
        30 : rd = 32'h0000001E;
        31 : rd = 32'h0000001F;
        default : rd = 32'h00000000;
    endcase

    case(reg_s1)
        9  : rs1 = 32'h00000009;
        18 : rs1 = 32'h00000012;
        19 : rs1 = 32'h00000013;
        20 : rs1 = 32'h00000014;
        21 : rs1 = 32'h00000015;
        22 : rs1 = 32'h00000016;
        23 : rs1 = 32'h00000017;
        24 : rs1 = 32'h00000018;
        25 : rs1 = 32'h00000019;
        26 : rs1 = 32'h0000001A;
        27 : rs1 = 32'h0000001B;
        
        //Temporal 
        5  : rs1 = 32'h00000005;
        6  : rs1 = 32'h00000006;
        7  : rs1 = 32'h00000007;
        28 : rs1 = 32'h0000001C;
        29 : rs1 = 32'h0000001D;
        30 : rs1 = 32'h0000001E;
        31 : rs1 = 32'h0000001F;
        default : rs1 = 32'h00000000;
    endcase

    hex_code = {immediate[11:0], rs1, func3, rd, opcode};   
    $display("hex code is : %h",hex_code);  
    //Write in file
    $fdisplay(file, "%h", hex_code);
end
endfunction

function void parser_S(input string operation,input int reg_s2,input integer immediate,input int reg_s1);
begin

    //variables
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [6:0] opcode;
    reg [6:0] func7;
    reg [2:0] func3;
    reg [31:0] hex_code;

    case(operation)//S-Type          
        "sb" :begin opcode = 7'h23; func3 = 3'h0;end
        "sh" : begin opcode = 7'h23; func3 = 3'h1; end
        "sw" : begin opcode = 7'h23; func3 = 3'h2; end
        "sd" : begin opcode = 7'h23; func3 = 3'h3; end
        default : begin opcode = 7'h00; func3 = 3'h0; end
    endcase

    case(reg_s1)
        9  : rs1 = 32'h00000009;
        18 : rs1 = 32'h00000012;
        19 : rs1 = 32'h00000013;
        20 : rs1 = 32'h00000014;
        21 : rs1 = 32'h00000015;
        22 : rs1 = 32'h00000016;
        23 : rs1 = 32'h00000017;
        24 : rs1 = 32'h00000018;
        25 : rs1 = 32'h00000019;
        26 : rs1 = 32'h0000001A;
        27 : rs1 = 32'h0000001B;
        
        //Temporal 
        5  : rs1 = 32'h00000005;
        6  : rs1 = 32'h00000006;
        7  : rs1 = 32'h00000007;
        28 : rs1 = 32'h0000001C;
        29 : rs1 = 32'h0000001D;
        30 : rs1 = 32'h0000001E;
        31 : rs1 = 32'h0000001F;
        default : rs1 = 32'h00000000;
    endcase

    case(reg_s2)
//Saved
        9  : rs2 = 32'h00000009;
        18 : rs2 = 32'h00000012;
        19 : rs2 = 32'h00000013;
        20 : rs2 = 32'h00000014;
        21 : rs2 = 32'h00000015;
        22 : rs2 = 32'h00000016;
        23 : rs2 = 32'h00000017;
        24 : rs2 = 32'h00000018;
        25 : rs2 = 32'h00000019;
        26 : rs2 = 32'h0000001A;
        27 : rs2 = 32'h0000001B;
        
        //Temporal 
        5  : rs2 = 32'h00000005;
        6  : rs2 = 32'h00000006;
        7  : rs2 = 32'h00000007;
        28 : rs2 = 32'h0000001C;
        29 : rs2 = 32'h0000001D;
        30 : rs2 = 32'h0000001E;
        31 : rs2 = 32'h0000001F;
        default : rs2 = 32'h00000000;
    endcase
    
    hex_code = {immediate[11:5], rs2, rs1, func3,immediate[4:0], opcode};   
    $display("hex code is : %h",hex_code);
  
    //Write in file
    $fdisplay(file, "%h", hex_code);
end
endfunction

function void parser_J(input string operation,input int reg_d,input integer immediate);
begin

    //variables    
    reg [4:0] rd;
    reg [6:0] opcode;
    reg [31:0] hex_code;

    case(operation)//J-Type:
        "jal" : opcode = 7'h6F;
        default : opcode = 7'h00;      
    endcase

    case(reg_d)
        //Saved
        9  : rd = 32'h00000009;
        18 : rd = 32'h00000012;
        19 : rd = 32'h00000013;
        20 : rd = 32'h00000014;
        21 : rd = 32'h00000015;
        22 : rd = 32'h00000016;
        23 : rd = 32'h00000017;
        24 : rd = 32'h00000018;
        25 : rd = 32'h00000019;
        26 : rd = 32'h0000001A;
        27 : rd = 32'h0000001B;
        
        //Temporal 
        5  : rd = 32'h00000005;
        6  : rd = 32'h00000006;
        7  : rd = 32'h00000007;
        28 : rd = 32'h0000001C;
        29 : rd = 32'h0000001D;
        30 : rd = 32'h0000001E;
        31 : rd = 32'h0000001F;
        default : rd = 32'h00000000;
    endcase
    immediate = immediate <<1;
    hex_code = { immediate[20],immediate[10:1],immediate[11],immediate[19:12],rd, opcode};   

    $display("hex code is : %h",hex_code);
  
    //Write in file
    $fdisplay(file, "%h", hex_code);
end
endfunction

function void parser_U(input string operation,input int reg_d, input integer immediate);
begin

    //variables
    reg [4:0] rd;
    reg [6:0] opcode;
    reg [31:0] hex_code;

    case(operation)//U-Type
        "lui" : opcode = 7'h37;
        "auipc" : opcode = 7'h17;    
    endcase

    case(reg_d)
        //Saved
        9  : rd = 32'h00000009;
        18 : rd = 32'h00000012;
        19 : rd = 32'h00000013;
        20 : rd = 32'h00000014;
        21 : rd = 32'h00000015;
        22 : rd = 32'h00000016;
        23 : rd = 32'h00000017;
        24 : rd = 32'h00000018;
        25 : rd = 32'h00000019;
        26 : rd = 32'h0000001A;
        27 : rd = 32'h0000001B;
        
        //Temporal 
        5  : rd = 32'h00000005;
        6  : rd = 32'h00000006;
        7  : rd = 32'h00000007;
        28 : rd = 32'h0000001C;
        29 : rd = 32'h0000001D;
        30 : rd = 32'h0000001E;
        31 : rd = 32'h0000001F;
        default : rd = 32'h00000000;
    endcase
    //shifted because instruction set
    immediate = immediate << 12;

    hex_code = {immediate[31:12], rd, opcode};   
    
    $display("hex code is : %h",hex_code);
  
    //Write in file
    $fdisplay(file, "%h", hex_code);
end
endfunction

function void parser_B(input string operation,input int reg_s1,input int reg_s2,input integer immediate);
begin

    //variables
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg [6:0] opcode;
    reg [2:0] func3;
    reg [31:0] hex_code;
    
    case(operation)//B-Type
        "beq" :begin opcode = 7'h63; func3 = 3'h0;end
        "bne" :begin opcode = 7'h63; func3 = 3'h1;end
        "blt" :begin opcode = 7'h63; func3 = 3'h4;end
        "bge" :begin opcode = 7'h63; func3 = 3'h5;end
        "bltu" :begin opcode = 7'h63; func3 = 3'h6;end
        "bgeu" :begin opcode = 7'h63; func3 = 3'h7;end
        default:begin opcode = 7'h00; func3 = 3'h0;end
    endcase
     case(reg_s1)
        //Saved
               9  : rs1 = 32'h00000009;
        18 : rs1 = 32'h00000012;
        19 : rs1 = 32'h00000013;
        20 : rs1 = 32'h00000014;
        21 : rs1 = 32'h00000015;
        22 : rs1 = 32'h00000016;
        23 : rs1 = 32'h00000017;
        24 : rs1 = 32'h00000018;
        25 : rs1 = 32'h00000019;
        26 : rs1 = 32'h0000001A;
        27 : rs1 = 32'h0000001B;
        
        //Temporal 
        5  : rs1 = 32'h00000005;
        6  : rs1 = 32'h00000006;
        7  : rs1 = 32'h00000007;
        28 : rs1 = 32'h0000001C;
        29 : rs1 = 32'h0000001D;
        30 : rs1 = 32'h0000001E;
        31 : rs1 = 32'h0000001F;
        default : rs1 = 32'h00000000;
    endcase
    case(reg_s2)
        //Saved
        9  : rs2 = 32'h00000009;
        18 : rs2 = 32'h00000012;
        19 : rs2 = 32'h00000013;
        20 : rs2 = 32'h00000014;
        21 : rs2 = 32'h00000015;
        22 : rs2 = 32'h00000016;
        23 : rs2 = 32'h00000017;
        24 : rs2 = 32'h00000018;
        25 : rs2 = 32'h00000019;
        26 : rs2 = 32'h0000001A;
        27 : rs2 = 32'h0000001B;
        
        //Temporal 
        5  : rs2 = 32'h00000005;
        6  : rs2 = 32'h00000006;
        7  : rs2 = 32'h00000007;
        28 : rs2 = 32'h0000001C;
        29 : rs2 = 32'h0000001D;
        30 : rs2 = 32'h0000001E;
        31 : rs2 = 32'h0000001F;
        default : rs2 = 32'h00000000;
    endcase
    
    immediate = immediate <<1;
    hex_code = {immediate[12],immediate[10:5], rs2, rs1, func3, immediate[4:1],immediate[11], opcode};   

    $display("hex code is : %h",hex_code);
  
    //Write in file
    $fdisplay(file, "%h", hex_code);
end
endfunction

//MAIN
initial begin
    //Open file
    file = $fopen("file_data.txt", "w");

    //Test Cases input
    //R_input : ("inst","regD","reg1","reg2")
    //I_input : ("inst","regD","reg1",imm)
    //S_input : ("inst","reg2",imm,"reg1")
    //J_input : ("inst","regD",imm)
    //U_input : ("inst","regD",imm)
    //B_input : ("inst","reg1","reg2",imm)
/*CORNER CASE*/
    parser_U("lui",5,-3);
    parser_U("lui",7,-40);
    parser_R("add",31,7,5);    
/*CORNER CASE*/
    parser_U("lui",19,8'h1ff23abc);
    parser_S("sb",19,0,20);
/*CORNER CASE*/
    parser_U("lui",19,8'heeeeeeee);
    parser_U("lui",20,8'h11111111);
    parser_R("add",21,19,20);    
/*CORNER CASE*/
    parser_U("lui",19,8'heeeeeeee);
    parser_U("lui",20,8'heeeeeeee);
    parser_R("sub",30,19,20);   
/*CORNER CASE*/
    parser_U("lui",19,32'b10101010101010101010101010101010);
    parser_U("lui",20,32'b01010101010101010101010101010101);
    parser_R("xor",30,19,20);
/*CORNER CASE*/
    parser_U("lui",19,8'h1ffffff0);
    parser_U("lui",20,8'h10045202);
    parser_R("xor",30,19,20); 
/*CORNER CASE*/
    parser_U("lui",19,8'h1ffffff0);
    parser_I("srli",29,26,50);
/*CORNER CASE*/
    parser_U("lui",19,8'h1ffffff0);
    parser_I("srli",29,26,50);
/*CORNER CASE*/
    parser_U("lui",25,8'h8524fadd);
    parser_I("srli",27,25,8'hffffffff);
/*CORNER CASE*/
    parser_U("lui",25,8'hffffffff);
/*CORNER CASE*/
    parser_U("lui",25,8'h00000000);    
   
 //Senario 1.1,1.2,3.1.5,3.1.8
     parser_I("addi",18,18,12'hfff);
// senario 1.2,1.3,3.1.5
     parser_I("addi",19,19,12'hfff);
// senario 3.1.1 , 3.1.6
    parser_R("add",18,19,16);
// senario 3.1.5
    parser_I("addi",19,19,-1);
// senario 1.4 , 2.6
    parser_I("jalr",20,18,300);

// senario 3.1.2 , 3.1.6
    parser_R("add",20,19,0);
// senario 3.1.2 , 3.1.4
    parser_I("addi",20,19,-2);
// senario 3.1.3 , 3.1.7
    parser_R("add",18,18,19);
// senario 3.1.8
    parser_I("addi",18,19,12'hfff);
// senario 3.1.12
    parser_I("addi",22,22,0);
// senario 3.1.13
    parser_R("add",18,22,22);
// senario 3.1.14
    parser_I("addi",18,33,12'hfff);
// senario 3.1.15
    parser_R("addw",18,19,28);
// senario 3.1.16
    parser_I("addiu",18,19,20);

// senario 3.2.1 3.2.6 3.2.7
    parser_R("sub",18,19,29);
// senario 3.2.2 3.2.5
    parser_R("sub",18,18,21);
// senario 3.2.3 3.2.4
    parser_R("sub",18,19,29);

// senario 3.3.1
    parser_R("sll",18,20,20);
// senario 3.3.2 3.3.3 3.3.4
    parser_R("sll",18,20,20);
    parser_R("srl",18,20,20);
// senario 3.3.5
    parser_R("sll",18,23,23);
    parser_R("srl",18,23,23);
// senario 3.3.6
    parser_R("sra",18,22,22);
// senario 3.3.7
    parser_R("sra",18,22,22);
// senario 3.3.8
    parser_R("sra",18,22,22);
// senario 3.3.9
    parser_R("sra",18,22,22);
// senario 3.3.10
    parser_R("sra",18,20,20);
// senario 3.3.11
    parser_R("sra",18,20,20);
// senario 3.3.12
    parser_R("sra",18,21,21);
// senario 3.3.13
    parser_R("sra",18,23,23);

// senario 3.4.1
    parser_R("and",18,24,23);
    parser_R("or",18,24,23);
    parser_R("xor",18,24,23);
    parser_R("nor",18,24,23);
// senario 3.4.2
    parser_I("andi",18,23,12'hf0f);
    parser_I("ori",18,23,12'hf0f);
    parser_I("xori",18,23,12'hf0f);
// senario 3.4.3
    parser_R("and",18,23,23);
    parser_R("or",18,23,23);
    parser_R("xor",18,23,23);
    parser_R("nor",18,23,23);
// senario 3.4.4
    //s2=s7 and 0
    parser_I("andi",18,23,0);
    parser_I("ori",18,23,0);
    parser_I("xori",18,23,0);
// senario 3.4.5
    //s2=s5 and s5
    parser_R("and",18,21,21);
    //s2=s5 or s5
    parser_R("or",18,21,21);
    //s2=s5 xor s5
    parser_R("xor",18,21,21);
    //s2=s5 nor s5
    parser_R("nor",18,21,21);
// senario 3.4.6
    parser_I("andi",18,21,12'hfff);
    parser_I("ori",18,21,12'hfff);
    parser_I("xori",18,21,12'hfff);

// senario 3.5
    parser_U("lui",23,115);

// senario 3.6.1 , 3.6.2
    parser_B("beq",18,27,38);
    parser_B("beq",19,20,34);    
    parser_B("bnq",18,19,44);

// senario 3.7.1 3.7.2 3.7.3 3.7.4
    parser_S("sltiu",18,0,15);
    parser_S("sltiu",18,-1,16);
    parser_S("sltui",18,-1,26);
    parser_S("slti",18,10,15);

// senario 3.8.1
    parser_J("jr",23,100);
// senario 3.8.2
    parser_I("jalr",18,20,123);
// senario 3.8.3
    parser_J("jr",25,1023);

// senario 4.4 4.5 4.2 4.1 4.3
    parser_S("sw",20,19,12'hfff);
    parser_I("lw",18,19,12'hfff);
    parser_S("sw",20,0,19);
    parser_I("lw",18,0,16);

/*CORNER CASE*/
    parser_U("lui",5,-3);
    parser_U("lui",7,-40);
    parser_R("add",31,7,5);    
/*CORNER CASE*/
    parser_U("lui",19,8'h1ff23abc);
    parser_S("sb",19,0,20);
/*CORNER CASE*/
    parser_U("lui",19,8'heeeeeeee);
    parser_U("lui",20,8'h11111111);
    parser_R("add",21,19,20);    
/*CORNER CASE*/
    parser_U("lui",19,8'heeeeeeee);
    parser_U("lui",20,8'heeeeeeee);
    parser_R("sub",30,19,20);   
/*CORNER CASE*/
    parser_U("lui",19,32'b10101010101010101010101010101010);
    parser_U("lui",20,32'b01010101010101010101010101010101);
    parser_R("xor",30,19,20);
/*CORNER CASE*/
    parser_U("lui",19,8'h1ffffff0);
    parser_U("lui",20,8'h10045202);
    parser_R("xor",30,19,20); 
/*CORNER CASE*/
    parser_U("lui",19,8'h1ffffff0);
    parser_I("srli",29,26,50);
/*CORNER CASE*/
    parser_U("lui",19,8'h1ffffff0);
    parser_I("srli",29,26,50);
/*CORNER CASE*/
    parser_U("lui",25,8'h8524fadd);
    parser_I("srli",27,25,8'hffffffff);
/*CORNER CASE*/
    parser_U("lui",25,8'hffffffff);
/*CORNER CASE*/
    parser_U("lui",25,8'h00000000);    
   
    //Close file
    $fclose(file);
end

endmodule