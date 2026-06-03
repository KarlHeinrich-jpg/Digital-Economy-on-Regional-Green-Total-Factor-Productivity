function p=tra_mark(A,tt,Q1,Q2,Q3,Q4)
[n,t]=size(A);
info = zeros(n,t);
for i=1:t   
    for j=1:n
        if(A(j,i)<=Q1)
            info(j,i)=1;
        elseif(A(j,i)<=Q2)&&(A(j,i)>Q1)
            info(j,i)=2;
        elseif(A(j,i)<=Q3)&&(A(j,i)>Q2)   
            info(j,i)=3;
        elseif(A(j,i)<=Q4)&&(A(j,i)>Q3)   
            info(j,i)=4;
        else
            info(j,i)=5;
        end
    end
end
for j=1:5 
    aa0=0;ab0=0;ac0=0;ad0=0;ae0=0;
for i=1:t-tt
xx=info(:,i);
yy=info(:,i+tt);
weizhi1=find(xx==j);
aa=sum(yy(weizhi1)==1);
ab=sum(yy(weizhi1)==2);
ac=sum(yy(weizhi1)==3);
ad=sum(yy(weizhi1)==4);
ae=sum(yy(weizhi1)==5);
aa0=aa+aa0;
ab0=ab+ab0;
ac0=ac+ac0;
ad0=ad+ad0;
ae0=ae+ae0;
end
jieguo(j,:)=[aa0 ab0 ac0 ad0 ae0];
end
p=[jieguo./repmat(sum(jieguo,2),1,5) sum(jieguo,2)];
end

