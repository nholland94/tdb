SHELL=/bin/bash

ATSCC=patscc
FILTER=pats-filter

define filter_template =
	$(1) 2>&1 | $(FILTER)
	if [ $${PIPESTATUS[0]} -nz ]; then rm $(2); exit 1; fi
endef

%_dats.c: %.dats
	$(call filter_template, $(ATSCC) -c $<, $@)
	# $(ATSCC) -c $< 2>&1 | $(FILTER)
	# if [ $${PIPESTATUS[0]} -nz ]; then rm $@; exit 1; fi

test3: test3_dats.c utf8_dats.c
	$(call filter_template, $(ATSCC) -o $@ $^, $@)
