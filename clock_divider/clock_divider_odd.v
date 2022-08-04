//  奇数分频时钟

module clock_divider_odd #(
    parameter   TCQ     =   1,
    parameter   C_DIV   =   9,
    parameter   C_FLIP  =   4
) (
    input   wire    clk_i   ,
    input   wire    rst_i   ,
    output  wire    clk_div_o   
);

    reg [$clog2(C_DIV)-1:0] cnt     ;
    reg                     clk_div ;

    always @(posedge clk_i) begin
        if (rst_i) begin
            cnt <=  #TCQ 'd0;
        end else if (cnt == C_DIV-1) begin
            cnt <=  #TCQ 'd0;
        end else begin
            cnt <= #TCQ cnt + 'd1;
        end
    end

    always @(posedge clk_i) begin
        if (rst_i) begin
            clk_div <=  #TCQ 'b0;
        end else if ((cnt == C_FLIP) || (cnt == C_DIV - 1)) begin
            clk_div <=  #TCQ ~clk_div;
        end
    end

    assign  clk_div_o   =   clk_div;
    
endmodule


module clock_divider_odd_or50 #(
    parameter   TCQ     =   1,
    parameter   C_DIV   =   9
) (
    input   wire    clk_i   ,
    input   wire    rst_i   ,
    output  wire    clk_div_o   
);

    reg [$clog2(C_DIV)-1:0] cnt     ;
    reg                     clk_div_pos ;
    reg                     clk_div_neg ;

    always @(posedge clk_i) begin
        if (rst_i) begin
            cnt <=  #TCQ 'd0;
        end else if (cnt == C_DIV-1) begin
            cnt <=  #TCQ 'd0;
        end else begin
            cnt <= #TCQ cnt + 'd1;
        end
    end

    always @(posedge clk_i) begin
        if (rst_i) begin
            clk_div_pos <=  #TCQ 'b0;
        end else if (cnt == C_DIV >> 1 - 1) begin
            clk_div_pos <=  #TCQ 'b0;
        end else if (cnt == C_DIV - 1) begin
            clk_div_pos <=  #TCQ 'b1;
        end
    end

    always @(negedge clk_i) begin
        if (rst_i) begin
            clk_div_neg <=  #TCQ 'b0;
        end else if (cnt == C_DIV >> 1 - 1) begin
            clk_div_neg <=  #TCQ 'b0;
        end else if (cnt == C_DIV - 1) begin
            clk_div_neg <=  #TCQ 'b1;
        end
    end

    assign  clk_div_o   =   clk_div_pos | clk_div_neg;

endmodule

module clock_divider_odd_and50 #(
    parameter   TCQ     =   1,
    parameter   C_DIV   =   9
) (
    input   wire    clk_i   ,
    input   wire    rst_i   ,
    output  wire    clk_div_o   
);

    reg [$clog2(C_DIV)-1:0] cnt     ;
    reg                     clk_div_pos ;
    reg                     clk_div_neg ;

    always @(posedge clk_i) begin
        if (rst_i) begin
            cnt <=  #TCQ 'd0;
        end else if (cnt == C_DIV-1) begin
            cnt <=  #TCQ 'd0;
        end else begin
            cnt <= #TCQ cnt + 'd1;
        end
    end

    always @(posedge clk_i) begin
        if (rst_i) begin
            clk_div_pos <=  #TCQ 'b0;
        end else if (cnt == C_DIV >> 1) begin
            clk_div_pos <=  #TCQ 'b0;
        end else if (cnt == C_DIV - 1) begin
            clk_div_pos <=  #TCQ 'b1;
        end
    end

    always @(negedge clk_i) begin
        if (rst_i) begin
            clk_div_neg <=  #TCQ 'b0;
        end else if (cnt == C_DIV >> 1) begin
            clk_div_neg <=  #TCQ 'b0;
        end else if (cnt == C_DIV - 1) begin
            clk_div_neg <=  #TCQ 'b1;
        end
    end

    assign  clk_div_o   =   clk_div_pos & clk_div_neg;

endmodule