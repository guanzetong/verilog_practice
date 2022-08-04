//  小数分频

module clock_divider_frac #(
    parameter   TCQ         =   1   ,
    parameter   C_SRC_NUM   =   76  ,
    parameter   C_DES_NUM   =   10
)(
    input   wire    clk_i       ,
    input   wire    rst_i       ,
    output  wire    clk_div_o   
);

    parameter   C_DIV_0 =   C_SRC_NUM / C_DES_NUM;
    parameter   C_DIV_1 =   C_DIV_0 + 1;
    parameter   C_ACC   =   C_SRC_NUM - C_DIV_0 * C_DES_NUM;

    reg     [$clog2(C_DIV_1)-1:0]       div_reg     ;
    reg     [$clog2(C_DIV_1)-1:0]       cnt         ;
    reg     [$clog2(C_DES_NUM)-1:0]     acc         ;
    wire    [$clog2(C_DES_NUM*2)-1:0]   acc_raw     ;
    wire                                div_end     ;

    assign  acc_raw =   acc + C_ACC;

    always @(posedge clk_i) begin
        if (rst_i) begin
            acc <=  #TCQ 'd0;
        end else if (div_end) begin
            if (acc_raw >= C_DES_NUM) begin
                acc <=  #TCQ acc_raw - C_DES_NUM;
            end else begin
                acc <=  #TCQ acc_raw;
            end
        end
    end

    assign  div_end =   (cnt == div_reg - 1);

    always @(posedge clk_i) begin
        if (rst_i) begin
            cnt <=  #TCQ 'd0;
        end else if (div_end) begin
            cnt <=  #TCQ 'd0;
        end else begin
            cnt <=  #TCQ cnt + 'd1;
        end
    end

    always @(posedge clk_i) begin
        if (rst_i) begin
            div_reg <=  #TCQ C_DIV_0;
        end else if (div_end) begin
            if (acc_raw >= C_DES_NUM) begin
                div_reg <=  #TCQ C_DIV_1;
            end else begin
                div_reg <=  #TCQ C_DIV_0;
            end
        end
    end


endmodule