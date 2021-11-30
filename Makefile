FULL_DIR := full-archives
SPLIT_DIR := split-archives

CONCAT_EXEC := concat-archives.sh
SPLIT_EXEC := split-archives.sh

.PHONY: all
all: concat

.PHONY: concat
concat:
	bash $(CONCAT_EXEC) $(SPLIT_DIR) $(FULL_DIR)

.PHONY: clean
clean:
	-rm -rfv $(FULL_DIR)