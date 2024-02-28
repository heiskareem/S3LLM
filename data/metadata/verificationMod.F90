module verificationMod 
contains 
subroutine update_vars_LakeTemperature(gpu,desc)
     use ColumnDataType, only : col_ws 
     use ColumnDataType, only : col_wf 
     use ColumnDataType, only : col_es 
     use elm_instMod, only : lakestate_vars 
     use elm_instMod, only : ch4_vars 
     use VegetationDataType, only : veg_ef 
     use ColumnDataType, only : col_ef 
     implicit none 
     integer, intent(in) :: gpu
     character(len=*), optional, intent(in) :: desc
     character(len=256) :: fn
     if(gpu) then
          fn="gpu_LakeTemperature"
     else
          fn='cpu_LakeTemperature'
     end if
     if(present(desc)) then
          fn = trim(fn) // desc
     end if
     fn = trim(fn) // ".txt"
     print *, "Verfication File is :",fn
     open(UNIT=10, STATUS='REPLACE', FILE=fn)
     if(gpu) then
     !$acc update self(& 
     !$acc col_ws%h2osoi_liq, & 
     !$acc col_ws%h2osoi_ice, & 
     !$acc col_ws%snow_depth, & 
     !$acc col_ws%frac_iceold, & 
     !$acc col_ws%h2osno )
     !$acc update self(& 
     !$acc col_wf%qflx_snofrz_lyr, & 
     !$acc col_wf%qflx_snofrz, & 
     !$acc col_wf%qflx_snow_melt, & 
     !$acc col_wf%qflx_snomelt )
     !$acc update self(& 
     !$acc col_es%t_lake, & 
     !$acc col_es%t_soisno, & 
     !$acc col_es%hc_soi, & 
     !$acc col_es%hc_soisno )
     !$acc update self(& 
     !$acc lakestate_vars%lakeresist_col, & 
     !$acc lakestate_vars%lake_icefrac_col, & 
     !$acc lakestate_vars%savedtke1_col, & 
     !$acc lakestate_vars%betaprime_col, & 
     !$acc lakestate_vars%lake_icethick_col )
     !$acc update self(& 
     !$acc ch4_vars%grnd_ch4_cond_col )
     !$acc update self(& 
     !$acc veg_ef%eflx_sh_grnd, & 
     !$acc veg_ef%eflx_soil_grnd, & 
     !$acc veg_ef%eflx_sh_tot, & 
     !$acc veg_ef%eflx_gnet )
     !$acc update self(& 
     !$acc col_ef%imelt, & 
     !$acc col_ef%eflx_snomelt, & 
     !$acc col_ef%errsoi )
     end if 
     !! CPU print statements !! 
     write(10,*) 'col_ws%h2osoi_liq' 
     write(10,*) col_ws%h2osoi_liq
     write(10,*) 'col_ws%h2osoi_ice' 
     write(10,*) col_ws%h2osoi_ice
     write(10,*) 'col_ws%snow_depth' 
     write(10,*) col_ws%snow_depth
     write(10,*) 'col_ws%frac_iceold' 
     write(10,*) col_ws%frac_iceold
     write(10,*) 'col_ws%h2osno' 
     write(10,*) col_ws%h2osno
     write(10,*) 'col_wf%qflx_snofrz_lyr' 
     write(10,*) col_wf%qflx_snofrz_lyr
     write(10,*) 'col_wf%qflx_snofrz' 
     write(10,*) col_wf%qflx_snofrz
     write(10,*) 'col_wf%qflx_snow_melt' 
     write(10,*) col_wf%qflx_snow_melt
     write(10,*) 'col_wf%qflx_snomelt' 
     write(10,*) col_wf%qflx_snomelt
     write(10,*) 'col_es%t_lake' 
     write(10,*) col_es%t_lake
     write(10,*) 'col_es%t_soisno' 
     write(10,*) col_es%t_soisno
     write(10,*) 'col_es%hc_soi' 
     write(10,*) col_es%hc_soi
     write(10,*) 'col_es%hc_soisno' 
     write(10,*) col_es%hc_soisno
     write(10,*) 'lakestate_vars%lakeresist_col' 
     write(10,*) lakestate_vars%lakeresist_col
     write(10,*) 'lakestate_vars%lake_icefrac_col' 
     write(10,*) lakestate_vars%lake_icefrac_col
     write(10,*) 'lakestate_vars%savedtke1_col' 
     write(10,*) lakestate_vars%savedtke1_col
     write(10,*) 'lakestate_vars%betaprime_col' 
     write(10,*) lakestate_vars%betaprime_col
     write(10,*) 'lakestate_vars%lake_icethick_col' 
     write(10,*) lakestate_vars%lake_icethick_col
     write(10,*) 'ch4_vars%grnd_ch4_cond_col' 
     write(10,*) ch4_vars%grnd_ch4_cond_col
     write(10,*) 'veg_ef%eflx_sh_grnd' 
     write(10,*) veg_ef%eflx_sh_grnd
     write(10,*) 'veg_ef%eflx_soil_grnd' 
     write(10,*) veg_ef%eflx_soil_grnd
     write(10,*) 'veg_ef%eflx_sh_tot' 
     write(10,*) veg_ef%eflx_sh_tot
     write(10,*) 'veg_ef%eflx_gnet' 
     write(10,*) veg_ef%eflx_gnet
     write(10,*) 'col_ef%imelt' 
     write(10,*) col_ef%imelt
     write(10,*) 'col_ef%eflx_snomelt' 
     write(10,*) col_ef%eflx_snomelt
     write(10,*) 'col_ef%errsoi' 
     write(10,*) col_ef%errsoi
     close(10)
end subroutine 
end module verificationMod
