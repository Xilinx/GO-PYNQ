t=VehicleBTimeSeries.Time;

V(:,1)=VehicleBTimeSeries.Data(:,3);
V(:,2)=VehicleBTimeSeries1.Data(:,3);
V(:,3)=VehicleBTimeSeries2.Data(:,3);
V(:,4)=VehicleBTimeSeries3.Data(:,3);
V(:,5)=VehicleBTimeSeries4.Data(:,3);
V(:,6)=VehicleBTimeSeries5.Data(:,3);
V(:,7)=VehicleBTimeSeries6.Data(:,3);
V(:,8)=VehicleBTimeSeries7.Data(:,3);
V(:,9)=VehicleBTimeSeries8.Data(:,3);
V(:,10)=VehicleBTimeSeries9.Data(:,3);
V(:,11)=VehicleBTimeSeries10.Data(:,3);
V(:,12)=VehicleBTimeSeries11.Data(:,3);
V(:,13)=VehicleBTimeSeries12.Data(:,3);
V(:,14)=VehicleBTimeSeries9.Data(:,3);
V(:,15)=VehicleBTimeSeries10.Data(:,3);
V(:,16)=VehicleBTimeSeries11.Data(:,3);

[b a] = fir1(5,[0.2]);

V1 = filter(b,a,V);
V1=V1(10:end,:);
t1=t(10:end,1);
plot(t1,V1)
xlim([3 400])
