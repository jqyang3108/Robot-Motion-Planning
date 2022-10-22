function [R,L,C] = HandleEventPoint(p,left_end_line_seg,right_end_line_seg,S)
% Function Name:  HandleEventPoint(p,left_end_line_seg,right_end_line_seg,S)
% Vertical cell decomposition for planar rigid-body robot cases
% inputs:
% -p: point p on vertical sweep line
% -left_end_line_seg: Line segments whose left endpoints are p
% -right_end_line_seg: Line segments whose right endpoints are p
% -S: All the line segments of obs
%
% Ouputs:
% -R: Subset of segments found whose right endpoint is p
% -L: subset of segments found whose left endpoint is p
% -C: subset of segments found that contain p in their interior.


%%
L = {};
R = {};
C = {};
T = {};
%% 1. Let L(p) be the set of segments whose left endpoint is p; these segments are stored with the
for i = 1:size(left_end_line_seg,2)
   if p == left_end_line_seg{i}(2,1)   %% if point p is the left end point of segment in left_end_line_seg
      L = [L,{left_end_line_seg{i} }] ;
   end
end
%% Let R(p) denote the subset of segments found whose right endpoint is p
for i = 1:size(right_end_line_seg,2)
   if p == right_end_line_seg{i}(2,1)   %% if point p is the right end point of segment in left_end_line_seg
      R = [R,{right_end_line_seg{i} }] ;
   end
end
%%  let C(p) denote the subset of segments found that contain p in their interior.
for j = 5:size(S,2)      % each segment 
    start_P_x = S{j}(1,1);
    end_P_x = S{j}(2,1);
    if ((p>start_P_x)&&(p<end_P_x))||((p<start_P_x)&&(p>end_P_x))|| ((start_P_x==p)&&(end_P_x==p))
        if  any(cellfun(@(x) isequal(x, S{j}), C))~=1
            C = [C,{S{j}}];
        end
    end   
    %% 2.Find all segments stored in T that contain p; they are adjacent in T.
    if ((start_P_x == p)||(end_P_x== p))||((p>start_P_x)&&(p<end_P_x))||((p<start_P_x)&&(p>end_P_x))
       T = [{S{j}},T] ;
    end 
end
%% If L(p) ∪ R(p) ∪ C(p) contains more than one segment
num_RLC = size([R,L,C]);
if num_RLC(2)>1  
   fprintf("\n p is an intersection at %.1f \n\n",p) 
    return
end
%%  Delete the segments in R(p) ∪ C(p) from T.
%{
RC = [R,C];
temp_T = T;
T = {};

num_RC = size(RC);
num_T = size(temp_T);
for i = 1:num_T(2)
   t = temp_T{i} ;
   for j = 1:num_RC(2)
        if t == RC{j}
            temp_T{i} = [];
        end
   end
   if isempty(temp_T{i}) == 0
      T = [T, {temp_T{i}}]; 
   end
end

%% Insert the segments in L(p) ∪ C(p) into T.
LC = [L,C]   ;

num_LC = size(LC);
num_T = size(T);

for i = 1:num_LC(2)  %% for every segment in LUC
    midpoint_LC = (LC{i}(1,2)+LC{i}(2,2))/2;
    for j = 2:num_T(2)       
        if (isequal(LC{i},T{j})||isequal(LC{i},T{j-1}))==1
            break;
        end
        midpoint_T = (T{j}(1,2)+T{j}(2,2))/2;
        %[(T{j-1}(1,2)+T{j-1}(2,2))/2  midpoint_LC  midpoint_T]
        if (T{j-1}(1,2)+T{j-1}(2,2))/2 < midpoint_LC  %% if LC is at the top
            T = [LC{i} ,T];
            break        
        elseif ((T{j-1}(1,2)+T{j-1}(2,2))/2 > midpoint_LC)&&((T{j}(1,2)+T{j}(2,2))/2 < midpoint_LC)
            T = [T{1:j-1},LC{i}, T{j-1:num_T(2)}];
            break       
        else
            if(LC{i} ~= T{j})
                T = [T,LC{i}]
            end
        end       
    end    
end
%% 8

%}
end
