function NewNetwork = ConstructNetwork_Fcn(Network,P)
IW = Network.IW{1}; IW_Num = numel(IW);
LW = Network.LW{2}; LW_Num = numel(LW);
b = Network.b{1};

IWP = reshape(P(1:IW_Num),size(IW,1),size(IW,2));
LWP = reshape(P(IW_Num+1:IW_Num+LW_Num),size(LW,1),size(LW,2));

bP = reshape(P(IW_Num+LW_Num+1:end),size(b,1),size(b,2));

NewNetwork = Network;
NewNetwork.IW{1} = IWP;
NewNetwork.LW{2} = LWP;
NewNetwork.b{1} = bP;
end
