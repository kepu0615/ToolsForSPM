# ToolsForSPM
githubの使い方よく分かっていません。  
現在、自分が使用している作業用スクリプトをこのレポジトリ上に少しずつアップロードしていこうと思います。  
PythonとMATLABがメインです。
  
## triming_brain_figure.py
使いたい関数の引数にトリミングしたい画像のパスを入れてください。  
トリミング後の画像は以下のように、同じディレクトリ内に別名で保存されます。  
「(元のファイル名).(拡張子)」 --> 「(元のファイル名)_resize.(拡張子)」  

## save_result_cluster.m
スクリプトのコメントアウトに従って適宜直せば実行できるかと思います。  
SPM.matがあるディレクトリ内に
- Tableのpng
- 各閾値でのnifti(e.g. spmT_0001_positive_unc_0_001.nii)
- 各閾値でのTableのcsv(e.g. Unmodulated_positive_cluster_0_05.csv)

が保存されます。  
