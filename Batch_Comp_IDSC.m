function [dismat] = Batch_Comp_IDSC(ifname, n_contsamp,n_dist,n_theta,num_start,thre)
                            
n_objall=length(ifname);
%num_start	= 8;
search_step	= 1;

%-- shape context parameters
%thre		= .6;
%-- shape context parameters
bTangent	= 1;
bSmoothCont	= 1;

SC	= cell(n_objall,1);
SC1 = cell(n_objall,1);

for iC=1:n_objall
 im	= double(imread(ifname{iC}));
% bReflect
 im1	= fliplr(im);
 fg_mask	= double(im>.5);
% bReflect
 fg_mask1	= double(im1>.5);		
 cont = extract_longest_cont(im, n_contsamp);
% bReflect
 ifig	= -1;
 [sc,V,E,dis_mat,ang_mat] = compu_contour_innerdist_SC( ...
											cont, fg_mask, ...
											n_dist, n_theta, bTangent, bSmoothCont,...
											ifig);
 SC{iC}	= sc;
 cont = extract_longest_cont(im1, n_contsamp);
% bReflect
 [sc,V,E,dis_mat,ang_mat] = compu_contour_innerdist_SC( ...
											cont, fg_mask1, ...
											n_dist, n_theta, bTangent, bSmoothCont,...
											ifig);
		
 
% bReflect
 SC1{iC} = sc;
end

 %-Compute distance matrix
dismat	= zeros(n_objall,n_objall);
for i1=1:n_objall
	for i2=1:n_objall
		if i1~=i2
            [dis_sc,costmat1]	= dist_bw_sc_C( SC{i1},SC1{i2}, 0);
			[dis_sc,costmat]	= dist_bw_sc_C( SC{i1},SC{i2}, 0);
			[cvec,cost]		= DPMatching_C(costmat,thre,num_start,search_step);
            [cvec,cost1]		= DPMatching_C(costmat1,thre,num_start,search_step);
			dismat(i1,i2)		= min(cost,cost1);
		end
	end
end

dismat	= min(dismat,dismat');
end


