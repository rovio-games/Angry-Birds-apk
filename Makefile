FULL_DIR := full-archives
SPLIT_DIR := split-archives

CONCAT_EXEC := concat-archives.sh
SPLIT_EXEC := split-archives.sh

.PHONY: all
all: concat

.PHONY: concat
concat: $(FULL_DIR)

$(FULL_DIR):
	bash $(CONCAT_EXEC) $(SPLIT_DIR) $(FULL_DIR)

.PHONY: split
split: $(FULL_DIR)
	bash $(SPLIT_EXEC) $(FULL_DIR) $(SPLIT_DIR)

.PHONY: clean
clean:
	-rm -rfv $(FULL_DIR)