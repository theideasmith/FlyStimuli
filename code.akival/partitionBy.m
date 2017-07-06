function Ks = partitionBy(tot, K, p)
    % We simulate a random process that
    % adds and removes from partitions. To do that,
    % we need to determine what the distribution of
    % partition sizes will be. We will ignore the issues
    % of rounding as for my purposes I dont actually care
    % about these distributions.
    % In theory, we could sample from a multinomial for
    % more accurate results and easier analysis,
    % but I chose gaussian first and will just go with it.
    % Suppose we'd like the distribution of partition sizes
    % to follow a gaussian distribution.
    % Then
    %           Ks(i) ~ N(mu, sigma)            (1)
    % subject to
    %           sum(Ns) = tot                    (2)
    % where mu = tot/partitions and sigma is computed
    % algorithmically below.
    % Then we have
    %           P(sum) ~ N(mu_sum, sigma_sum)      (3)
    % where
    %           mu_sum = K*mu
    %           sigma_sum = K*sigma^2
    % We choose a sigma so that the probability of
    % going overboard is very low. Something like p=10%
    %
    % So then we do the computation:
    %           P(sum <= T) = I(Z <= (sum-mu_sum)/(sigma_sum) ) = p
    %`          I(Z <= (sum-mu_sum)/sigma_sum) = p
    %           (sum-mu_sum)/sigma_sum = IInv(p)
    %           sigma_sum = (sum-mu_sum)/IInv(p)
    %           sigma = sqrt(sigma_sum/K)
    % If p is very low then the distribution of partition
    % sizes will converge to the uniform distribution after pruning.
    % I think the best strategy is to generate and then prune.
    % We sample from the gaussian and then try to spread the pruning
    % weight over the entire array.
    % Algorithm:
    % (1) Sample K numbers, Ks(i) from the gaussian
    %           Ks(i) ~ N(tot/K, (K*tot-tot)/(K*IInv(p)))
    % (2) Choose pruning factors,
    %           dKDiv = round((tot-sum(Ks))/K)
    %           dKMod = floor((tot-sum(ks)) % K)
    % (3) Sample K indices, prunIdxs, from 1:dKMod without replacement
    % (3) Ks(:,:) -= dKDiv
    % (4) Ks(prunIdxs,:) -= 1
    %% Initial sampling
    mu = (tot)/(2*K);
    mu_sum = tot/2;
    sigma_sum = (tot-mu_sum)/norminv(p);
    sigma = sqrt(sigma_sum/K);
    Ks = floor(normrnd(mu, sigma, K,1));
    if sum(Ks) ~= tot
        Delta = sum(Ks)-tot;
        %% Pruning factors
        dKDiv = sgnFloor(Delta/K);
        dKMod = mod(abs(Delta), K);
        %% Pruning
        Ks(:) = Ks(:) - dKDiv;
        if dKMod >0
            prunIdxs = datasample(find(Ks(1:K)>0), abs(dKMod), 'Replace', false);
            Ks(prunIdxs, :) = Ks(prunIdxs, :) - sign(Delta);
        end
    end
end

function res = sgnCeil(val)
    res = sign(val)*ceil(abs(val));
end

function res = sgnFloor(val)
    res = sign(val)*floor(abs(val));
end
