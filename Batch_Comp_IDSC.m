function [SC,dismat] = Batch_Comp_IDSC(ifname, n_contsamp,n_dist,n_theta,num_start,thre,bReflect)
                            
n_objall=length(ifname);
%num_start	= 8;
search_step	= 1;

%-- shape context parameters
%thre		= .6;
%-- shape context parameters
bTangent	= 1;
bSmoothCont	= 1;
bSimplecont	= 1;
%bReflect=0;

SC	= cell(n_objall,1);

for iC=1:n_objall
 im	= double(imread(ifname{iC}));
 if bReflect
  im	= fliplr(im);
 end
  fg_mask	= double(im>.5);		
 cont = extract_longest_cont(im, n_contsamp);
 ifig	= -1;
 if bSimplecont
  [sc,V,E,dis_mat,ang_mat] = compu_contour_innerdist_SC( ...
											cont, fg_mask, ...
											n_dist, n_theta, bTangent, bSmoothCont,...
											ifig);
 else
  [sc,V,E,dis_mat,ang_mat] = compu_multi_contour_innerdist_SC( ...
											cont, fg_mask, ...
											n_dist, n_theta, bTangent, bSmoothCont,...
											ifig);
 end
		
 SC{iC}	= sc;

 end
 %-Compute distance matrix
dismat	= zeros(n_objall,n_objall);
for i1=1:n_objall
	for i2=i1:n_objall
		if i1~=i2
			[dis_sc,costmat]	= dist_bw_sc_C( SC{i1},SC{i2}, 0);
			[cvec,cost1]		= DPMatching_C(costmat,thre,num_start,search_step);
			dismat(i1,i2)		= cost1;
		end
	end
end

dismat	= dismat+dismat';
end


