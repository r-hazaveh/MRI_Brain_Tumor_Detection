
function NewCountry = GenerateNewPop(NumOfCountries,ProblemParams)

    VarMinMatrix = repmat(ProblemParams.VarMin,1,NumOfCountries);
    VarMaxMatrix = repmat(ProblemParams.VarMax,1,NumOfCountries);
    [dim,n]=size(VarMinMatrix);
    NewCountry = rand(dim,n).*(VarMaxMatrix - VarMinMatrix) + VarMinMatrix;

end