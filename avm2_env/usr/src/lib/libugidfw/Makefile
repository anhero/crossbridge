# $FreeBSD: src/lib/libugidfw/Makefile,v 1.9.2.1.6.1 2010/12/21 17:09:25 kensmith Exp $

LIB=		ugidfw
SHLIB_MAJOR=	4
SRCS=		ugidfw.c
INCS=		ugidfw.h

MAN+=		bsde_get_rule.3 bsde_get_rule_count.3 bsde_parse_rule.3 \
		bsde_rule_to_string.3 libugidfw.3

MLINKS= 	bsde_get_rule.3 bsde_add_rule.3
MLINKS+= 	bsde_get_rule.3 bsde_delete_rule.3
MLINKS+=	bsde_get_rule.3 bsde_set_rule.3
MLINKS+=	bsde_get_rule_count.3 bsde_get_rule_slots.3
MLINKS+=	bsde_parse_rule.3 bsde_parse_rule_string.3

.include <bsd.lib.mk>
