//  偶数分频时钟

module clock_divider_even #(
    parameter TCQ   =   1,
    parameter C_DIV =   10
)(
    input   wire    clk_i,
    input   wire    rst_i,
    output  wire    clk_div_o
);

    reg  [$clog2(C_DIV/2)-1:0]  cnt         ;
    reg                         clk_div     ;

    always @(posedge clk_i) begin
        if (rst_i) begin
            cnt <=  #TCQ 'd0;
        end else begin
            if (cnt >= (C_DIV/2 - 1)) begin
                cnt <=  #TCQ 'd0;
            end else begin
                cnt <=  #TCQ cnt + 'd1;
            end
        end
    end

    always @(posedge clk_i) begin
        if (rst_i) begin
            clk_div <=  #TCQ 'b0;
        end else if (cnt < (C_DIV/2)) begin
            clk_div <=  #TCQ ~clk_div;
        end
    end

    assign  clk_div_o   =   clk_div;

endmodule