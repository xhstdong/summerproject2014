function VQ_Method( train_dir,test_dir,n)
%Cover function for the entire Vector Quantization Process
%   Detailed explanation goes here

result=train(train_dir,n);
test(test_dir,n,result,train_dir);

end

