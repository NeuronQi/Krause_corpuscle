The matlab codes here are for the paper “Krause corpuscles are genital vibrotactile sensors for sexual behaviours”.

The quantification of the density of Krause corpuscles in Fig.1 h-j was performed using the “DistributionGC_3D.mlx” matlab live script code. Three files were required before running the code: the first one is the Z-projection image of a tissue section (200um thick in the paper); the second is the roi file created in ImageJ by using the freehand tool to outline the perimeter of the section; the third is the csv file that stores the x and y location of the Krause corpuscles that were manually labeled in ImageJ using the “Multi-Point” tool. This live script uses the “Bio-Formats” package (https://www.openmicroscopy.org/bio-formats/downloads/) and a function, ROIs2Regions_LQ.m, modified from ROIs2Regions.m (https://github.com/DylanMuir/ReadImageJROI/blob/master/ROIs2Regions.m).

The quantification of the spinal cord terminal in Extended Data Fig. 5 f, g was performed using the “sacral_cord.mlx”. The ROI file for two lines is needed to align all spinal cord sections. The ROI file for the two lines were created in ImageJ: the first line goes from midpoint of dorsal surface of spinal cord to the center of central canal; the second line goes from midpoint of dorsal surface of spinal cord to the bottom of dorsal column. This livescript uses the Bio-Formats” package (https://www.openmicroscopy.org/bio-formats/downloads/) and custom functions including uniprofile.m.

The ethograms of the male sexual reflex behaviors were plotted using the “reflex.mlx”. The behaviors were manually quantified and exported using BORIS (https://www.boris.unito.it/). The live script uses custom functions including ethoSingle.m and ethopatch.m.

The ethograms of the female sexual reflex behaviors were plotted using the “pressure.mlx”. 

The mating behaviors of the male mice were quantified using “mating.mlx”.

The mating behaviors of the hormone-primed female mice were quantified using “mating_female.mlx”.

The mating behaviors of the naturally-cycling female mice were quantified using “mating_female_nc.mlx”.
