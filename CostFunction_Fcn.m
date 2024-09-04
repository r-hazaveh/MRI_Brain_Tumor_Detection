function Cost = CostFunction_Fcn(Pop,CostFuncExtraParams)

Network = CostFuncExtraParams.Network;
Xtr = CostFuncExtraParams.Xtr;
Ytr = CostFuncExtraParams.Ytr;

[dim,PopSize ]=size(Pop);
Cost = zeros(1,PopSize);

for ii = 1:PopSize
    P = Pop(:,ii);
    NewNetwork = ConstructNetwork_Fcn(Network,P);
    YtrNet = sim(NewNetwork,Xtr')';
    Cost(ii) = mse(Ytr-YtrNet);
end

end

