SELECT rp.CALENDAR_YEAR,
       rp.FOREST_FILE_ID,
       rp.BILLABLE_NON_USE_IND,
       rp.MAX_NO_OF_CATTLE,
       rp.MAX_NO_OF_HORSES,
       rp.MAX_NO_OF_OTHER_LIVESTOCK,
       rp.MAX_NO_OF_SHEEP,
       rp.NONUSE_FORAGE_TONNES,
       rp.TOTAL_AUTHORIZED_GRAZBL_FORAGE,
       rp.TOTAL_PRIVATE_LAND_GRAZ_FORAGE,
       rt.ADMIN_FOREST_DISTRICT_NO,
       rt.AUTHORIZED_HARVEST_TONNES,
       rt.HAY_CUTTING_AREA_NO,
       rt.
FROM WHSE_FOREST_TENURE.FTEN_RANGE_PROVISION rp
  LEFT JOIN WHSE_FOREST_TENURE.FTEN_RANGE_TENURE rt ON (rp.FOREST_FILE_ID = rt.FOREST_FILE_ID)
WHERE ROWNUM < 200;