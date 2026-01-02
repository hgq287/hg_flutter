# Variables
SCRIPT = generate_project.sh
OUT_DIR = out
OLD_NAME = hg_flutter

.PHONY: generate clean check help

help:
	@echo "========================================"
	@echo "Flutter Template Generator"
	@echo "========================================"
	@echo "Commands:"
	@echo "  make generate name=my_app   - Clone, rename, and init"
	@echo "  make check name=my_app      - Verify no old names exist"
	@echo "  make clean                  - Clear the /out folder"

generate:
	@if [ -z "$(name)" ]; then \
		echo "Error: name= is required. Example: make generate name=flutter_sample"; \
		exit 1; \
	fi
	@chmod +x $(SCRIPT)
	@./$(SCRIPT) $(name)

check:
	@if [ -z "$(name)" ]; then \
		echo "Error: Provide the name to check. Example: make check name=flutter_sample"; \
		exit 1; \
	fi
	@echo "Final check for '$(OLD_NAME)' in $(OUT_DIR)/$(name)..."
	@if grep -r "$(OLD_NAME)" $(OUT_DIR)/$(name); then \
		echo "Old name detected in the files listed above."; \
	else \
		echo "SUCCESS: No occurrences of $(OLD_NAME) found."; \
		echo "   Project is compatible and ready to run."; \
	fi

clean:
	@rm -rf $(OUT_DIR)
	@echo "Cleaned output directory."