//  半整数分频

module clock_divider_half_int #(
    parameter   TCQ         =   1   ,
    parameter   C_DIV_MUL2  =   9   
) (
    input   wire    clk_i   ,
    input   wire    rst_i   ,
    output  wire    clk_div_o   
);

    reg [$clog2(C_DIV_MUL2)-1:0]    cnt     ;
    reg                             clk_avg ;
    reg                             clk_adj ;

    always @(posedge clk_i) begin
        if (rst_i) begin
            cnt <=  #TCQ 'd0;
        end else if (cnt == C_DIV_MUL2) begin
            cnt <=  #TCQ 'd0;
        end else begin
            cnt <=  #TCQ cnt + 'd1;
        end
    end

    always @(posedge clk_i) begin
        if (rst_i) begin
            clk_avg <=  #TCQ 'b0;
        end else if ((cnt == 0) || (cnt == (C_DIV_MUL2 >> 1))) begin
            clk_avg <=  #TCQ 'b1;
        end else begin
            clk_avg <=  #TCQ 'b0;
        end
    end

    always @(negedge clk_i) begin
        if (rst_i) begin
            clk_adj <=  #TCQ 'b0;
        end else if ((cnt == 1) || (cnt == (C_DIV_MUL2 >> 1))) begin
            clk_adj <=  #TCQ 'b1;
        end else begin
            clk_adj <=  #TCQ 'b0;
        end
    end

    assign  clk_div_o   =   clk_avg | clk_adj;
    
endmodule