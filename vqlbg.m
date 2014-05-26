function [ new_codebook] = vqlbg( audio_vecs, codebook,target_num )
%Vector Quantization using LBG method
%   Input: the set of training audio vectors
%           previous codebook, which is a set of column vectors

num_codebook=size(codebook,2);
delta=0.01;
threshold=5;
dimensions=size(audio_vecs,1);
%in first iteration, find the one centroid of the entire space
if num_codebook==0
    codebook=find_centroid(audio_vecs);
%     plot(audio_vecs(1,:),audio_vecs(2,:),'LineStyle', 'none','Marker','+','MarkerEdgeColor','r','MarkerSize',10)
%     hold on
%     plot(codebook(1,:),codebook(2,:),'LineStyle', 'none','Marker','*','MarkerEdgeColor','b','MarkerSize',10)
     num_codebook=1;
end

%centroid splitting
%each centroid is split into two by shifting a bit in opposite directions
new_codebook=zeros(dimensions,2*num_codebook); %2d vectors for now
for i=1:num_codebook
    new_codebook(:,i)=codebook(:,i) * (1+delta);
    new_codebook(:,i+num_codebook)=codebook(:,i) * (1-delta);
    %plot(new_codebook(1,:),new_codebook(2,:),'LineStyle', 'none','Marker','*','MarkerEdgeColor','g','MarkerSize',10)
end
distance=threshold+1;
loop=0;
while (distance>threshold && loop<100)
    %loop until the new codebook is sufficiently close
    dist=disteu(audio_vecs,new_codebook);
    % the rows are audio_vec size, columns are new_codebook size
    %categorize each audio_vec under the new codebook
    for i=1:size(audio_vecs,2) %number of column vectors
        [distance(i),nearest_book(i)]=min(dist(i,:),[],2);
    end %nearest_book(i) is the codebook number to which it belongs
    distance=mean(distance);
    new_codebook=zeros(dimensions, 2*num_codebook);
    C=cell(1,2*num_codebook);
    %update new codebook
    for i=1:size(new_codebook,2)
        for j=1:size(audio_vecs,2)
            if nearest_book(j)==i %if this vector is indeed closer to code i
                %then it goes into a 3-d bin just for these vectors
                C{i}=[C{i},audio_vecs(:,j)];
            end
        end
        %adjust centroid
        C{i}=mean(C{i},2);

    end
    loop=loop+1;

%end loop
    emptyCells=cellfun('isempty',C);
    erased_count=size(emptyCells,1);
    C(emptyCells)=[];
    new_codebook=cell2mat(C);
    %plot(new_codebook(1,:),new_codebook(2,:),'LineStyle', 'none','Marker','*','MarkerEdgeColor','g','MarkerSize',10)
    
end
disp(distance)
%hold off
%iterate until the target number 
if size(new_codebook,2)<(target_num-erased_count)
   new_codebook=vqlbg(audio_vecs,new_codebook,target_num-erased_count); 
end
end

