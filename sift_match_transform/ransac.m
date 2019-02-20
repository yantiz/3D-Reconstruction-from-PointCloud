function [model, pt_idx] = ransac(A, B, ransac_param)
% Args:
%   A, B: Point set A and B each with size m x n. m points with n
%         dimensions. [x, y, z]' for example.
%   ransac_param: Parameter setting for ransac algorithm 
% Returns:
%   model: Matrix containing Rotation and Translation matrix. [R, T; 0, 1]
%   pt_idx: vector of matched point indices 

sample_size = ransac_param.sample_size; % number of sample points to use
th_dist = ransac_param.th_dist; % distance threshold
itr_num = ransac_itr_num; % number of iteration
inl_ratio = ransac.inl_ratio;% inlier ratio

if sample_size < 3
    fprintf('Need more points to fit !');
    return
end

% transform to homogenous coord
match_num = size(A, 2);
A = [A; ones(1, match_num)];
B = [B; ones(1, match_num)];

inl_th = round(match_num*inl_ratio);
models = cell(1, itr_num);
inl_num = zeros(1, itr_num);

for i=1:1:itr_num
    sample_idx = rand_idx(match_num, sample_size); % return random index
    F = transform_solve(A(:,sample_idx), B(:,sample_idx));
    dist = dist_cal(F*A, B);
    inl_idx = find(dist<th_dist);
    inl_num(i) = length(inl_idx);
    if length(inl_idx)<inl_th
        continue;
    end
    models{i} = F;
end


[~,idx] = max(inl_num);
model = models{idx};
dist = dist_cal(model*A, B);
pt_idx = find(dist < thDist);

return