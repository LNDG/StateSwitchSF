function [allcoords, coordparcmatch] = coords_parcmatch(coordlist, parcfile, parcname)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[parcdata, parchead] = rest_ReadNiftiImage(parcfile);
parcmatchdata = zeros(size(parcdata));
nparcs = max(max(max(parcmatchdata)));

mnicoords=dlmread(coordlist);
ncoords=length(mnicoords(:,1));

%Tform = cat(1, parcnii.hdr.hist.srow_x, parcnii.hdr.hist.srow_y, parcnii.hdr.hist.srow_z, [0 0 0 1]); 
%Tform(1:3,4) = [-87, -126, -72];

for i = 1:ncoords
        
coord = (inv(parchead.mat))*[mnicoords(i,1); mnicoords(i,2); mnicoords(i,3); ones(size(mnicoords(1,:),1),1)];
coord = round(coord);

allcoords(i,:)=coord;

coordparcmatch(i,1)=parcdata(allcoords(i,1),allcoords(i,2),allcoords(i,3));

if coordparcmatch(i,1)~=0

parcmatchdata(parcdata==coordparcmatch(i,1))=i;

end

end

%write out parc match nii

% parcniiout.hdr = parcnii.hdr;
% parcniiout.img = parcmatchdata;
% save_nii(parcniiout,['sigcoords_' parcname 'parcmatch.nii'])

rest_WriteNiftiImage(parcmatchdata,parchead,['sigcoords_' parcname 'parcmatch.nii'])

end