function [vlast, i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16] = fcn(vlast,v1,v2,v3,v4,v5,v6,v7,v8,v9,v10,v11,v12,v13,v14,v15,v16)
v=zeros(16,1);
v(1)=v1;v(2)=v2;v(3)=v3;v(4)=v4;v(5)=v5;v(6)=v6;v(7)=v7;v(8)=v8;
v(9)=v9;v(10)=v10;v(11)=v11;v(12)=v12;v(13)=v13;v(14)=v14;v(15)=v15;v(16)=v16;

i=zeros(16,1);

%identify the best cell
vdelmin=min(v-vlast);
vmin=min(v);

score=zeros(16,1);
for j=1:16
    if(v(j)-vlast(j)==vdelmin)
        score(j)=score(j)+1;
        if(v(j)==vmin)
            score(j)=score(j)+1;
        end
    end
end

bestid = find(score==2,1);
if(bestid==0)
    bestid = find(score==1,1);
end

vmod=v;
bestid=11;

%switching_control
for j=1:16
    vmod(j)=(0.2*v(j)+0.8*vlast(j));
end

DSGCURRENT=-0.1;
windowmargin=0.01;
for j=1:16
    if(vmod(j)-vmod(bestid)>windowmargin)
    i(j)=DSGCURRENT;
    end
end

for j=1:16
    if(v(j)==3.82)
        i=-1*ones(1*16,1);
    end
end

vlast=v;
%create vlast in adv

i1=i(1);i2=i(2);i3=i(3);i4=i(4);i5=i(5);i6=i(6);i7=i(7);i8=i(8);
i9=i(9);i10=i(10);i11=i(11);i12=i(12);i13=i(13);i14=i(14);i15=i(15);i16=i(16);