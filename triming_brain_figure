# -*- coding: utf-8 -*-
from PIL import Image
import numpy as np

#SPMで作成したrenderをトリミング
def trim_spm_render(f):
    im = Image.open(f)
    im_crop = im.crop((120, 1065, 900,1265)) #box=(left, upper, right, lower)
    im_crop.save(f.replace('.png','_resize.png'), quality=95)

#xjviewで作成したrenderをトリミング
def trim_xjview_render(f):
    im = Image.open(f)
    im_crop_left = im.crop((640, 493, 832,650)) #box=(left, upper, right, lower)
    im_crop_right = im.crop((928, 493, 1120,650)) #box=(left, upper, right, lower)
    #画像を横に結合
    get_concat_h(im_crop_left, im_crop_right).save(f.replace('.png','_resize.png'))

#sloverで作成したsliceをトリミング    
def trim_spm_slice(f):
    im = Image.open(f)
    im_crop = im.crop((62, 120, 951,1440)) #box=(left, upper, right, lower)
    im_crop.save(f.replace('.png','_resize.png'), quality=95)
