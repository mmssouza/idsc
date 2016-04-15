function [cont_all] = batch_contour_f(sdir,ifname,n_contsamp,bReflect)

fprintf('Compute contours ......................... \n');
	
%cont_all		= cell(n_class*n_obj,1);

%% original contour
i_cur	= 1;
for iC=1:length(ifname)
	%figure(20); clf; hold on;
		im	= double(imread(ifname{iC}));
		im	= double(im>.5);
		if bReflect
			im	= fliplr(im);
		end

		%- Extract contour, count only the longest contours
		[Cs]	= boundary_extract_binary(im);
		n_max	= 0;
		i_max	= 0;
		for ii=1:length(Cs)
			if size(Cs{ii},2)>n_max
				n_max = size(Cs{ii},2);
				i_max = ii;
			end
		end
		cont	= Cs{i_max}';

		%- Remove redundant point in contours
		cont		= [cont; cont(1,:)];
		dif_cont	= abs(diff(cont,1,1));
		id_gd		= find(sum(dif_cont,2)>0.001);
		cont		= cont(id_gd,:);

		%- Force the contour to be anti-clockwisecomputed above is at the different orientation
		bClock		= is_clockwise(cont);
		if bClock	cont	= flipud(cont);		end

		%- Start from bottom left
		[min_v,id]	= min(cont(:,2)+cont(:,1));
		cont		= circshift(cont,[length(cont)-id+1]);


		%- Sampling if needed
		if exist('n_contsamp','var')
			[XIs,YIs]	= uniform_interp(cont(:,1),cont(:,2),n_contsamp-1);
			cont		= [cont(1,:); [XIs YIs]];
		end
		
		%- Save
		cont_all{i_cur}	= cont;
		i_cur		= i_cur+1;

		%- demo
		if(1)
% 			subplot(4,5,iO);	hold on;
% 			plot(cont(:,1),cont(:,2),'-');	
% 			plot(cont(1,1),cont(1,2),'r+');
% 			plot(cont(50,1),cont(50,2),'ro');
% 			title([i2s(length(cont))]);
% 			axis tight;	axis equal;	axis off;
		end
	end

%	print(20,'-r350', '-djpeg', [sdir 'cont_' num2str(iC) '.jpg']);
end
% save(sOriCont,'cont');
% 
% 
% %-output result
% if 1	% test
% 	i_cur	= 1;
% 	for iC=1:n_class
% 		for iO=1:n_obj
% 			%fprintf('%2d, original clockwise=%d\n', iO,bClock);
% 
% 			subplot(4,5,iO);	hold on;
% 			plot(cont(:,1),cont(:,2),'-');	
% 			plot(cont(1,1),cont(1,2),'r+');
% 			plot(cont(50,1),cont(50,2),'ro');
% 			title([i2s(length(cont))]);
% 			axis tight;	axis equal;	axis off;
% 	% 				drawnow, keyboard;				
% 		end
% 	end
% 	print(20,'-r350', '-djpeg', [sdir 'cont_' num2str(iC) '.jpg']);
% end
% 
% fprintf('\n    finished computing contours.\n');
