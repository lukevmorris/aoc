KDIR=../../../k

repl:
	@socat READLINE EXEC:"$(KDIR)/k $(KDIR)/repl.k"

%:%.k
	@$(KDIR)/k $<

watch:
	@ls *.k | entr -cpn $(KDIR)/k /_
