*更多数据，关注公众号【马克数据网】

***描述性统计
sum y x1 x2 x3 x4
logout, save(Descriptive) word replace: sum y x1 x2 x3 x4//***输出描述性统计结果,点击Descriptive.rtf，即可出现word版本的描述性统计表

***空间相关性检验(Moran检验）
clear
cd"C:\Program Files (x86)\Stata14\ado"  //定义路径，自己建立文件夹，将需要用到的矩阵和数据放进去。定义路径步骤：File—change working directory-找到目标文件夹
spatwmat using D,name(w) standardize  // D为矩阵，w 是矩阵行标准化新的命名，自己可以随意取。standardize为行标准化，可以根据自己的需要，选择是否需要进行行标准化
use shuju                           //shuju是自己的计算数据
keep if year==2009                 //可以逐年计算莫兰指数
spatgsa y,weights(w) moran geary twotail


***LM 检验
clear all
cd"C:\Program Files (x86)\Stata14\ado"   //定义路径
set matsize 5000
use D                                   //D为矩阵名称
spcs2xt var1-var30,matrix(aaa)time(9)
spatwmat using aaaxt,name(w)
clear
use shuju                      //调用论文数据huiguishuju1 
encode province,gen(pro)      //定义地区变量
xtset pro year               //定义时间变量
gen lny=ln(y)               //如果需要对变量取对数，则执行以下命令,不需要则自动忽略
gen lnx1=ln(x1)
gen lnx2=ln(x2)
gen lnx3=ln(x3)
reg lny lnx1 lnx2 lnx3 
spatdiag,weights(w)


***Hausman检验//即固定效应与随机效应检验选择检验
clear
cd"C:\Program Files (x86)\Stata14\ado"//定义路径
use shuju                             //调用数据
spatwmat using D, name(w)standardize  //调用矩阵D，并根据研究需要选择进行矩阵行标准化
encode province,gen(pro)
xtset pro year
gen lnny=ln(y)                      //根据研究需要，选择是否对变量取对数
gen lnx1=ln(x1)
gen lnx2=ln(x2)
gen lnx3=ln(x3)
xsmle lny lnx1 lnx2 lnx3, fe model(sdm) wmat(w) nolog noeffects
est store fe
xsmle lny lnx1 lnx2 lnx3, re model(sdm) wmat(w) nolog noeffects
est store re
hausman fe re


***检验地区固定效应、时间固定效应以及双固定效应，三种效应哪个最适合本文的研究

xsmle lny lnx1 lnx2 lnx3,fe model(sdm) wmat(w)type(ind)nolog effects
est store ind
xsmle lny lnx1 lnx2 lnx3,fe model(sdm) wmat(w)type(time)nolog effects
est store time
xsmle lny lnx1 lnx2 lnx3,fe model(sdm) wmat(w)type(both)nolog effects
est store both
lrtest both ind,df(10)
lrtest both time,df(10)
drop _est_ind _est_time _est_both


***LR 检验          //用来检验SDM模型能否退化为SEM、SAR模型

xsmle y x1 x2 x3,fe model(sdm)wmat(w)type(both)nolog effects
est store sdm
xsmle y x1 x2 x3,fe model(sar)wmat(w)type(both)nolog effects
est store sar
xsmle y x1 x2 x3,fe model(sem)emat(w)type(both)nolog effects
est store sem
lrtest sdm sar   //H0：空间杜宾模型可以简化为空间滞后模型
lrtest sdm sem  //H0：空间杜宾模型可以简化为空间误差模型


***WALD检验    //也是用来检验模型的适配性
clear all
cd"C:\Program Files (x86)\Stata14\ado"//定义路径
use shuju                             //调用数据
spatwmat using D.dta,name(w) standardize //调用数据矩阵D，并将其还行标准化
encode province,gen(pro)
xtset pro year
gen lny=ln(y)
gen lnx1=ln(x1)
gen lnx2=ln(x2)
gen lnx3=ln(x3)
xsmle lny lnx1 lnx2 lnx3,fe model(sdm) wmat(w)type(both)nolog noeffects 

test [Wx]x1 = [Wx]x2 = [Wx]x3=0
testnl ([Wx]x1 = -[Spatial]rho*[Main]x1)([Wx]x2 = -[Spatial]rho*[Main]x2)([Wx]x3= -[Spatial]rho*[Main]x3)



***SDM模型回归（空间杜宾模型）
clear all
cd"C:\Program Files (x86)\Stata14\ado"//定义路径
use shuju                             //调用数据
spatwmat using D.dta,name(w) standardize //调用数据矩阵D，并将其还行标准化
encode province,gen(pro)
xtset pro year
gen lny=ln(y)
gen lnx1=ln(x1)
gen lnx2=ln(x2)
gen lnx3=ln(x3)
xsmle lny lnx1 lnx2 lnx3,fe model(sdm) wmat(w)type(both)nolog noeffects  //fe和type(both)可以根据文章hausman检验和固定效应、时间效应、双向固定效应检验的结果进行相应的变换。



*SAR模型回归（空间滞后模型）
xsmle lny lnx1 lnx2 lnx3,fe model(sar) wmat(w)type(both)nolog noeffects


*SEM模型回归（空间误差模型）
xsmle  lny lnx1 lnx2 lnx3,fe model(sem) emat(w)type(both)nolog noeffects

