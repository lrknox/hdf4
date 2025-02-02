
/*
 * Copyright (c) 2009, Sun Microsystems, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * - Neither the name of Sun Microsystems, Inc. nor the names of its
 *   contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * xdr_array.c, Generic XDR routines impelmentation.
 *
 * Copyright (C) 1984, Sun Microsystems, Inc.
 *
 * These are the "non-trivial" xdr primitives used to serialize and de-serialize
 * arrays.  See xdr.h for more info on the interface to xdr.
 */
#if !defined(lint) && defined(SCCSIDS)
static char sccsid[] = "@(#)xdr_array.c 1.10 87/08/11 Copyr 1984 Sun Micro";
#endif

#include "h4config.h"

#include <stdio.h>
#include <string.h> /* for memset() */
#include <limits.h> /* for UINT_MAX */

#include "types.h"
#include "xdr.h"

#define LASTUNSIGNED ((u_int)0 - 1)

/*
 * XDR an array of arbitrary elements
 * *addrp is a pointer to the array, *sizep is the number of elements.
 * If addrp is NULL (*sizep * elsize) bytes are allocated.
 * elsize is the size (in bytes) of each element, and elproc is the
 * xdr procedure to call to handle each element of the array.
 */
/* addrp - array pointer */
/* sizep - number of elements */
/* maxsize - max numberof elements */
/* elsize - size in bytes of each element */
/* elproc - xdr routine to handle each element */
bool_t
xdr_array(XDR *xdrs, caddr_t *addrp, u_int *sizep, u_int maxsize, u_int elsize, xdrproc_t elproc)
{
    u_int   i;
    caddr_t target = *addrp;
    u_int   c; /* the actual element count */
    bool_t  stat = TRUE;
    u_int   nodesize;

    /* like strings, arrays are really counted arrays */
    if (!xdr_u_int(xdrs, sizep)) {
        return (FALSE);
    }
    c = *sizep;
    if ((c > maxsize || UINT_MAX / elsize < c) && (xdrs->x_op != XDR_FREE)) {
        return (FALSE);
    }
    nodesize = c * elsize;

    /*
     * if we are deserializing, we may need to allocate an array.
     * We also save time by checking for a null array if we are freeing.
     */
    if (target == NULL)
        switch (xdrs->x_op) {
            case XDR_ENCODE:
                break; /* keep gcc happy */
            case XDR_DECODE:
                if (c == 0)
                    return (TRUE);
                *addrp = target = calloc(1, nodesize);
                if (target == NULL) {
                    (void)fprintf(stderr, "xdr_array: out of memory\n");
                    return (FALSE);
                }
                (void)memset(target, 0, nodesize);
                break;

            case XDR_FREE:
                return (TRUE);
        }

    /*
     * now we xdr each element of array
     */
    for (i = 0; (i < c) && stat; i++) {
        stat = (*elproc)(xdrs, target);
        target += elsize;
    }

    /*
     * the array may need freeing
     */
    if (xdrs->x_op == XDR_FREE) {
        free(*addrp);
        *addrp = NULL;
    }
    return (stat);
}

/*
 * xdr_vector():
 *
 * XDR a fixed length array. Unlike variable-length arrays,
 * the storage of fixed length arrays is static and unfreeable.
 * > basep: base of the array
 * > size: size of the array
 * > elemsize: size of each element
 * > xdr_elem: routine to XDR each element
 */
bool_t
xdr_vector(XDR *xdrs, char *basep, u_int nelem, u_int elemsize, xdrproc_t xdr_elem)
{
    u_int i;
    char *elptr;

    elptr = basep;
    for (i = 0; i < nelem; i++) {
        if (!(*xdr_elem)(xdrs, elptr)) {
            return (FALSE);
        }
        elptr += elemsize;
    }
    return (TRUE);
}
