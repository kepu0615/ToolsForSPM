%line12,17の実行毎に適宜書き換えてください
%line28の引数にはMRIcronをDLした際に一緒にDLされるbrodmann.nii.gzのパスを入れてください

clearvars
tic

%---------------------この中を自分で書き換える---------------------%
%{
spmmat      : tableを表示させたいSPM.matの絶対パス
spmmat_name : spmmatの説明(xyz_nameの1列目に表示)
%}

spmmat={'E:\hoge\1\SPM.mat';...
    'E:\hoge\2\SPM.mat';...
    'E:\hoge\3\SPM.mat'};
spmmat_name={'hoge1';'hoge2';'hoge3'};
%-----------------------------------------------------------------%

%0.数があっているか確認
if(size(spmmat,1)~=size(spmmat_name,1))
    disp('SPM.matと名前の数が一致していません');
    return
end

%0.for文回すための前処理
xyz_name={};
num_mat = size(spmmat,1); %matファイルの数
BA_area = spm_read_vols(spm_vol('C:\hoge\mricron\templates\brodmann.nii.gz'));
for I=1:num_mat
    addpath("C:\hoge\MATLAB")
    addpath("C:\hoge\spm12")
    
%1.Result表示(uncorrected, p<0.001)
    matlabbatch{1}.spm.stats.results.spmmat = spmmat(I,:);
    matlabbatch{1}.spm.stats.results.conspec.titlestr = 'title';
    matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 0.001;
    matlabbatch{1}.spm.stats.results.conspec.extent = 0;
    matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
    matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.export{1}.tspm.basename = 'positive_unc_0_001';
    
    spm('defaults', 'FMRI');
    spm_jobman('run', matlabbatch);
    
%1-1.Result表示(positive)(cluster-level FWE, p<0.05)
    fwe_c = TabDat.ftr{5, 2}(1,3);
    clear matlabbatch
    matlabbatch{1}.spm.stats.results.spmmat = spmmat(I,:);
    matlabbatch{1}.spm.stats.results.conspec.titlestr = spmmat_name{I,1};
    matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 0.001;
    matlabbatch{1}.spm.stats.results.conspec.extent = fwe_c;
    matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
    matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.export{1}.png = true;
    matlabbatch{1}.spm.stats.results.export{2}.tspm.basename = 'positive_cluster_0_05';
    
    spm('defaults', 'FMRI');
    spm_jobman('run', matlabbatch);

%1-2.Tableの作成
    result_all_table={};
    for i=1:size(TabDat.dat,1)
        result_table={};
        if TabDat.dat{i,3}>=0
            xyz={};
            
            xyz           = TabDat.dat{i,12};
            p_cluster_FWE = TabDat.dat{i,3};
            cluster_size  = TabDat.dat{i,5};
            t_value       = TabDat.dat{i,9};
            
            anatomical_name = spm_atlas('query', 'Neuromorphometrics',xyz);
            BA_number = BA_area(xyz(1,1)+91,xyz(2,1)+126,xyz(3,1)+72);
            
            result_table{1,1} = anatomical_name;
            result_table{1,2} = cluster_size; 
            result_table{1,3} = BA_number; 
            result_table{1,4} = t_value;
            result_table{1,5} = p_cluster_FWE;
            result_table{1,6} = xyz(1,1); 
            result_table{1,7} = xyz(2,1);
            result_table{1,8} = xyz(3,1);
            
        end
        result_all_table = vertcat(result_all_table, result_table);
    end
    result_all_table = vertcat({'anatomical name', 'cluster size', 'BA','t-value','p_cluster_FWE','x','y','z'}, result_all_table);
    fname = strcat(erase(spmmat{I,1},'SPM.mat'), spmmat_name{I,1},'_positive_cluster_0_05.csv');
    if size(TabDat.dat, 1) ~= 0
        writecell(result_all_table, fname);
    end

%2-1.negative_cluster.niiの保存
    clear matlabbatch
    matlabbatch{1}.spm.stats.results.spmmat = spmmat(I,:);
    matlabbatch{1}.spm.stats.results.conspec.titlestr = 'title';
    matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 0.001;
    matlabbatch{1}.spm.stats.results.conspec.extent = 0;
    matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
    matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.export{1}.tspm.basename = 'negative_unc_0_001';
    
    spm('defaults', 'FMRI');
    spm_jobman('run', matlabbatch);
    
    fwe_c = TabDat.ftr{5, 2}(1,3);
    clear matlabbatch
    matlabbatch{1}.spm.stats.results.spmmat = spmmat(I,:);
    matlabbatch{1}.spm.stats.results.conspec.titlestr = spmmat_name{I,1};
    matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 0.001;
    matlabbatch{1}.spm.stats.results.conspec.extent = fwe_c;
    matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
    matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.export{1}.png = true;
    matlabbatch{1}.spm.stats.results.export{2}.tspm.basename = 'negative_cluster_0_05'; %negativeの保存も自動化したい
    
    spm('defaults', 'FMRI');
    spm_jobman('run', matlabbatch);
    clear matlabbatch

%2-2.Tableの作成
    result_all_table={};
    for i=1:size(TabDat.dat,1)
        result_table={};
        if TabDat.dat{i,3}>=0
            xyz={};
            
            xyz           = TabDat.dat{i,12};
            p_cluster_FWE = TabDat.dat{i,3};
            cluster_size  = TabDat.dat{i,5};
            t_value       = TabDat.dat{i,9};
            
            anatomical_name = spm_atlas('query', 'Neuromorphometrics',xyz);
            BA_number = BA_area(xyz(1,1)+91,xyz(2,1)+126,xyz(3,1)+72);
            
            result_table{1,1} = anatomical_name;
            result_table{1,2} = cluster_size; 
            result_table{1,3} = BA_number; 
            result_table{1,4} = t_value;
            result_table{1,5} = p_cluster_FWE;
            result_table{1,6} = xyz(1,1); 
            result_table{1,7} = xyz(2,1);
            result_table{1,8} = xyz(3,1);
            
        end
        result_all_table = vertcat(result_all_table, result_table);
    end
    result_all_table = vertcat({'anatomical name', 'cluster size', 'BA','t-value','p_cluster_FWE','x','y','z'}, result_all_table);
    fname = strcat(erase(spmmat{I,1},'SPM.mat'), spmmat_name{I,1},'_negative_cluster_0_05.csv');
    if size(TabDat.dat, 1) ~= 0
        writecell(result_all_table, fname);
    end
    
end

toc
