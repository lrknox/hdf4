/*********************************************************************
 *   Copyright 1993, UCAR/Unidata
 *   See netcdf/COPYRIGHT file for copying and redistribution conditions.
 *********************************************************************/

/*
 * utility functions to update in-memory netcdf by adding new
 * dimensions, variables, and attributes.
 */
#include <stdio.h>
#include <string.h>

#include "h4config.h"
#ifdef H4_HAVE_NETCDF
#include "netcdf.h"
#else
#include "hdf4_netcdf.h"
#endif

#include "testcdf.h"
#include "add.h"
#include "alloc.h"
#include "emalloc.h"
#ifdef HDF
#include "hdf.h"
#endif

struct netcdf test; /*
                     * in-memory netcdf structure, kept in sync
                     * with disk netcdf
                     */

/* add the dimension idim to the netcdf test */
void
add_dim(struct netcdf *test, struct cdfdim *idim)
{
    static char pname[] = "add_dim";

    if (test->ndims >= H4_MAX_NC_DIMS) {
        (void)fprintf(stderr, "%s: too many dimensions (%d)", pname, test->ndims);
        return;
    }
    test->dims[test->ndims].size = idim->size;
    test->dims[test->ndims].name = (char *)emalloc(strlen(idim->name) + 1);
    (void)strcpy(test->dims[test->ndims].name, idim->name);
    if (idim->size == NC_UNLIMITED)
        test->xdimid = test->ndims;
    test->ndims++;
}

/* add the variable ivar to the netcdf test */
void
add_var(struct netcdf *test, struct cdfvar *ivar)
{
    static char pname[] = "add_var";
    int         i;

    if (test->nvars >= H4_MAX_NC_VARS) {
        (void)fprintf(stderr, "%s: too many variables (%d)", pname, test->nvars);
        return;
    }

    test->vars[test->nvars].name = (char *)emalloc(strlen(ivar->name) + 1);
    (void)strcpy(test->vars[test->nvars].name, ivar->name);
    test->vars[test->nvars].type  = ivar->type;
    test->vars[test->nvars].ndims = ivar->ndims;
    test->vars[test->nvars].dims  = (int *)emalloc(sizeof(int) * ivar->ndims);
    for (i = 0; i < ivar->ndims; i++)
        test->vars[test->nvars].dims[i] = ivar->dims[i];
    test->vars[test->nvars].natts = 0;
    test->nvars++;
}

/* add attribute iatt to the netcdf test */
void
add_att(struct netcdf *test, int varid, struct cdfatt *iatt)
{
    static char pname[] = "add_att";
    int         ia; /* attribute number */

    if (test->natts >= MAX_TEST_ATTS) {
        (void)fprintf(stderr, "%s: too many attributes (%d)", pname, test->natts);
        return;
    }

    /* if already defined, change existing attribute and return */
    for (ia = 0; ia < test->natts; ia++) {
        if (test->atts[ia].var == varid && strcmp(test->atts[ia].name, iatt->name) == 0) {
            test->atts[ia].type = iatt->type;
            test->atts[ia].len  = iatt->len;
            test->atts[ia].val  = iatt->val;
            return;
        }
    }
    /* otherwise, add new attribute to list */
    test->atts[test->natts].var  = varid;
    test->atts[test->natts].name = (char *)emalloc(strlen(iatt->name) + 1);
    (void)strcpy(test->atts[test->natts].name, iatt->name);
    test->atts[test->natts].type = iatt->type;
    test->atts[test->natts].len  = iatt->len;
    test->atts[test->natts].val  = iatt->val;
    test->natts++;
    if (varid == NC_GLOBAL)
        test->ngatts++;
    else
        test->vars[varid].natts++;
}

/* reset in-memory netcdf test to empty */
void
add_reset(struct netcdf *test)
{
    test->ndims  = 0;
    test->nvars  = 0;
    test->natts  = 0;
    test->ngatts = 0;
    test->xdimid = -1; /* no unlimited dimension */
}

/* delete attribute iatt in the netcdf test */
void
del_att(struct netcdf *test, int varid, struct cdfatt *iatt)
{
    static char pname[] = "del_att";
    int         ia, ib; /* attribute number */

    for (ia = 0; ia < test->natts; ia++) { /* find attribute to delete */
        if (test->atts[ia].var == varid && strcmp(test->atts[ia].name, iatt->name) == 0) {
            Free(test->atts[ia].name);
            for (ib = ia + 1; ib < test->natts; ib++) { /* move down */
                test->atts[ib - 1].var  = test->atts[ib].var;
                test->atts[ib - 1].name = test->atts[ib].name;
                test->atts[ib - 1].type = test->atts[ib].type;
                test->atts[ib - 1].len  = test->atts[ib].len;
                test->atts[ib - 1].val  = test->atts[ib].val;
            }
            test->natts--;
            if (varid == NC_GLOBAL)
                test->ngatts--;
            else
                test->vars[varid].natts--;
            return;
        }
    }
    /* not found */
    (void)fprintf(stderr, "%s: no such attribute as (%s, %s)", pname, test->vars[varid].name, iatt->name);
}

/* keep max record written updated */
void
add_data(struct netcdf *test, int varid, long start[], long edges[])
{
    if (varid != test->xdimid) /* not a record variable */
        return;
    if (start[0] + edges[0] > test->dims[test->xdimid].size)
        test->dims[test->xdimid].size = start[0] + edges[0];
}

void
errvar(struct netcdf *cdfp, struct cdfvar *varp)
{
    const char *types;
    int         id;

    switch (varp->type) {
        case NC_BYTE:
            types = "NC_BYTE";
            break;
        case NC_CHAR:
            types = "NC_CHAR";
            break;
        case NC_SHORT:
            types = "NC_SHORT";
            break;
        case NC_LONG:
            types = "NC_LONG";
            break;
        case NC_FLOAT:
            types = "NC_FLOAT";
            break;
        case NC_DOUBLE:
            types = "NC_DOUBLE	";
            break;
        default:
            types = "UNKNOWN";
            break;
    }

    (void)fprintf(stderr, "  name=%s  type=%s  dims=(", varp->name, types);
    for (id = 0; id < varp->ndims; id++)
        (void)fprintf(stderr, "%d%s", (int)cdfp->dims[varp->dims[id]].size, id < varp->ndims - 1 ? ", " : "");
    (void)fprintf(stderr, ")\n");
}
