Select count(*) from export_permit_detail pd 
left join export_scale_detail sd on (sd.export_detail_permit_number = pd.export_detail_permit_number)
left join export_grade_code gc on (gc.export_grade_code = pd.export_grade_code)
left join export_species_code sc on (sc.export_species_code = pd.export_species_code)
left join hauling_authority ha on (ha.timber_mark = sd.timber_mark)
left join export_exemption ee on (ee.exemption_number = pd.exemption_number)
;