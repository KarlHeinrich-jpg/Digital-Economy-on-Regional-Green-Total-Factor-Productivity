function p=tra_mark(A,tt,Q1,Q2)
[n,t]=size(A);
info = zeros(n,t);
for i=1:t   
    for j=1:n
        if(A(j,i)<=Q1)
            info(j,i)=1;
        elseif(A(j,i)<=Q2)&&(A(j,i)>Q1)
            info(j,i)=2;
        else
            info(j,i)=3;
        end
    end
end
for j=1:3 
    aa0=0;ab0=0;ac0=0;ad0=0;
for i=1:t-tt
xx=info(:,i);
yy=info(:,i+tt);
weizhi1=find(xx==j);
aa=sum(yy(weizhi1)==1);
ab=sum(yy(weizhi1)==2);
ac=sum(yy(weizhi1)==3);

aa0=aa+aa0;
ab0=ab+ab0;
ac0=ac+ac0;

end
jieguo(j,:)=[aa0 ab0 ac0];
end
p=[jieguo./repmat(sum(jieguo,2),1,3) sum(jieguo,2)];
end

