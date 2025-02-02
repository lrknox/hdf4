#include "mfhdf.h"

#define FILE_NAME      "SDS.hdf"
#define FILE_ATTR_NAME "File_contents"
#define SDS_ATTR_NAME  "Valid_range"
#define DIM_ATTR_NAME  "Dim_metric"

int
main()
{
    /************************* Variable declaration **************************/

    int32 sd_id, sds_id, sds_index;
    int32 dim_id, dim_index;
    int32 n_values; /* number of values of the file, SDS or
                       dimension attribute         */
    char8 file_values[] = "Storm_track_data";
    /* values of the file attribute */
    float32 sds_values[2] = {2., 10.};
    /* values of the SDS attribute  */
    char8 dim_values[] = "Seconds";
    /* values of the dimension attribute */

    /********************* End of variable declaration ***********************/

    /*
     * Open the file and initialize the SD interface.
     */
    if ((sd_id = SDstart(FILE_NAME, DFACC_WRITE)) == FAIL)
        printf("*** ERROR from SDstart\n");

    /*
     * Set an attribute that describes the file contents.
     */
    n_values = 16;
    if (SDsetattr(sd_id, FILE_ATTR_NAME, DFNT_CHAR, n_values, (VOIDP)file_values) == FAIL)
        printf("*** ERROR from SDsetattr\n");

    /*
     * Select the first data set.
     */
    sds_index = 0;
    sds_id    = SDselect(sd_id, sds_index);

    /*
     * Assign attribute to the first SDS. Note that attribute values
     * may have different data type than SDS data.
     */
    n_values = 2;
    if (SDsetattr(sds_id, SDS_ATTR_NAME, DFNT_FLOAT32, n_values, (VOIDP)sds_values) == FAIL)
        printf("*** ERROR from SDsetattr\n");

    /*
     * Get the the second dimension identifier of the SDS.
     */
    dim_index = 1;
    dim_id    = SDgetdimid(sds_id, dim_index);

    /*
     * Set an attribute of the dimension that specifies the dimension metric.
     */
    n_values = 7;
    if (SDsetattr(dim_id, DIM_ATTR_NAME, DFNT_CHAR, n_values, (VOIDP)dim_values) == FAIL)
        printf("*** ERROR from SDsetattr\n");

    /*
     * Terminate access to the data set.
     */
    if (SDendaccess(sds_id) == FAIL)
        printf("*** ERROR from SDendaccess\n");

    /*
     * Terminate access to the SD interface and close the file.
     */
    if (SDend(sd_id) == FAIL)
        printf("*** ERROR from SDend\n");

    return 0;
}
