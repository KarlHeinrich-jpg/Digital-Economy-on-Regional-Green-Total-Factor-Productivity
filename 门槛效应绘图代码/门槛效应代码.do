*（7）=============================门槛效应=============================//门槛变量为d
use data,clear
xtset id year
xthreg y  c1 c2 c3 c4 c5 c6 , rx(x) qx(d) trim(0.05) thnum(1) grid(400) bs(300)
//一重门槛，P值显著则使用二重门槛，直到不显著为止
xthreg y  c1 c2 c3 c4 c5 c6 , rx(x) qx(d) trim(0.05 0.05) thnum(2) grid(400) bs(300 300)
//二重门槛，P值显著则使用三重门槛，直到不显著为止
xthreg y  c1 c2 c3 c4 c5 c6 , rx(x) qx(d) trim(0.05 0.05 0.05) thnum(3) grid(400) bs(300 300 300)  
outreg2 using 门槛效应1, word replace
//选择合适的几重门槛后输出门槛效应结果
_matplot e(LR), columns(1 2) yline(7.35, lpattern(dash)) connect(direct) msize(small) mlabp(0) mlabs(zero) ytitle("LR Statistics") xtitle("First Threshold") recast(line) scheme(burd)
//一重门槛画图
_matplot e(LR21), columns(1 2) yline(7.35, lpattern(dash)) connect(direct) msize(small) mlabp(0) mlabs(zero) ytitle("LR Statistics") xtitle("First Threshold") recast(line) scheme(burd) name(LR12)
_matplot e(LR22), columns(1 2) yline(7.35, lpattern(dash)) connect(direct) msize(small) mlabp(0) mlabs(zero) ytitle("LR Statistics") xtitle("2nd Threshold") recast(line) scheme(burd) name(LR22)
graph combine LR12 LR22,cols(1) scheme(burd)
//二重门槛画图
//曲线最低点低于LR（虚线）时，表示门槛值是真实的