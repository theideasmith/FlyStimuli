function corrected = dotCorrectedPositionalData(pObserver, pSubject, V, n)

% Computes projections onto planes of a list of points
% pObserver is a (T D) matrix
% pSubject is a (nSbjs T D) matrix
% V is a (T D) matrix
% n is a (1 D) matrix


[nSbjs, T, D] = size(pSubject);
corrected = zeros(T, nSbjs, D); 
for i=1:nSbjs
  if T > 1
    res = round(planarProjection(pObserver, squeeze(pSubject(i,:,:)), V, n));
  else 
    res = round(planarProjection(pObserver, squeeze(pSubject(i,:,:))', V, n));
  end
  corrected(:,i,:) = res;
end
