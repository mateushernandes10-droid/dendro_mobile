CREATE TABLE activity_logs (
  id TEXT NOT NULL PRIMARY KEY,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  subtitle TEXT NOT NULL DEFAULT '',
  entity_type TEXT NULL,
  entity_id TEXT NULL,
  occurred_at INTEGER NOT NULL
);
CREATE TABLE "formula_coefficients" ("id" TEXT NOT NULL, "formula_id" TEXT NOT NULL REFERENCES formulas (id) ON DELETE CASCADE, "symbol" TEXT NOT NULL, "label" TEXT NOT NULL, "value" REAL NULL, PRIMARY KEY ("id"), UNIQUE(formula_id, symbol));
CREATE TABLE "formula_variables" ("id" TEXT NOT NULL, "formula_id" TEXT NOT NULL REFERENCES formulas (id) ON DELETE CASCADE, "symbol" TEXT NOT NULL, "label" TEXT NOT NULL, "unit" TEXT NOT NULL, "value_source" TEXT NOT NULL, "variable_key" TEXT NOT NULL, PRIMARY KEY ("id"), UNIQUE(formula_id, symbol));
CREATE TABLE "formulas" ("id" TEXT NOT NULL, "name" TEXT NOT NULL UNIQUE, "description" TEXT NULL, "expression" TEXT NOT NULL, "active" INTEGER NOT NULL DEFAULT 1 CHECK ("active" IN (0, 1)), "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
CREATE TABLE "inventory_runs" ("id" TEXT NOT NULL, "property_id" TEXT NOT NULL REFERENCES properties (id) ON DELETE CASCADE, "status" TEXT NOT NULL, "started_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, "completed_at" INTEGER NULL, PRIMARY KEY ("id"));
CREATE TABLE "plot_geo_points" ("id" TEXT NOT NULL, "plot_id" TEXT NOT NULL REFERENCES plots (id) ON DELETE CASCADE, "point_order" INTEGER NOT NULL, "reference_position" TEXT NULL, "latitude" REAL NOT NULL, "longitude" REAL NOT NULL, "accuracy_meters" REAL NULL, "captured_at" INTEGER NOT NULL, PRIMARY KEY ("id"), UNIQUE(plot_id, point_order));
CREATE TABLE "plots" ("id" TEXT NOT NULL, "talhao_levantamento_id" TEXT NOT NULL REFERENCES talhao_levantamentos (id) ON DELETE CASCADE, "identification" TEXT NOT NULL, "status" TEXT NOT NULL, "area_ha" REAL NULL, "reference_position" TEXT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"), UNIQUE(talhao_levantamento_id, identification));
CREATE TABLE "properties" ("id" TEXT NOT NULL, "name" TEXT NOT NULL, "municipality" TEXT NOT NULL, "state" TEXT NOT NULL DEFAULT 'RS', "total_area_ha" REAL NOT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
CREATE TABLE "species" ("id" TEXT NOT NULL, "name" TEXT NOT NULL UNIQUE, "scientific_name" TEXT NULL, "description" TEXT NULL, "active" INTEGER NOT NULL DEFAULT 1 CHECK ("active" IN (0, 1)), "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"));
CREATE TABLE "species_formula_coefficients" ("id" TEXT NOT NULL, "species_id" TEXT NOT NULL REFERENCES species (id) ON DELETE CASCADE, "formula_id" TEXT NOT NULL REFERENCES formulas (id) ON DELETE CASCADE, "symbol" TEXT NOT NULL, "label" TEXT NOT NULL, "value" REAL NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"), UNIQUE(species_id, formula_id, symbol));
CREATE TABLE "species_formulas" ("species_id" TEXT NOT NULL REFERENCES species (id) ON DELETE CASCADE, "formula_id" TEXT NOT NULL REFERENCES formulas (id) ON DELETE CASCADE, "is_default" INTEGER NOT NULL DEFAULT 0 CHECK ("is_default" IN (0, 1)), "created_at" INTEGER NOT NULL, PRIMARY KEY ("species_id", "formula_id"));
CREATE TABLE "stands" ("id" TEXT NOT NULL, "property_id" TEXT NOT NULL REFERENCES properties (id) ON DELETE CASCADE, "identification" TEXT NOT NULL, "species_id" TEXT NOT NULL REFERENCES species (id) ON DELETE RESTRICT, "area_ha" REAL NOT NULL, "planting_year" INTEGER NULL, "spacing" TEXT NULL, "management_regime" TEXT NULL, "plot_width_m" REAL NULL, "plot_length_m" REAL NULL, "notes" TEXT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"), UNIQUE(property_id, identification));
CREATE TABLE talhao_formula_coefficients (
  id TEXT NOT NULL PRIMARY KEY,
  talhao_levantamento_id TEXT NOT NULL REFERENCES talhao_levantamentos(id) ON DELETE CASCADE,
  symbol TEXT NOT NULL,
  label TEXT NOT NULL,
  value REAL NULL,
  UNIQUE(talhao_levantamento_id, symbol)
);
CREATE TABLE "talhao_levantamentos" ("id" TEXT NOT NULL, "inventory_run_id" TEXT NOT NULL REFERENCES inventory_runs (id) ON DELETE CASCADE, "stand_id" TEXT NOT NULL REFERENCES stands (id) ON DELETE CASCADE, "species_id" TEXT NOT NULL REFERENCES species (id) ON DELETE RESTRICT, "formula_id" TEXT NOT NULL REFERENCES formulas (id) ON DELETE RESTRICT, "default_plot_area_ha" REAL NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"), UNIQUE(inventory_run_id, stand_id));
CREATE TABLE "trees" ("id" TEXT NOT NULL, "plot_id" TEXT NOT NULL REFERENCES plots (id) ON DELETE CASCADE, "number" INTEGER NOT NULL, "dap_cm" REAL NOT NULL, "height_m" REAL NOT NULL, "has_tortuous_stem" INTEGER NOT NULL DEFAULT 0 CHECK ("has_tortuous_stem" IN (0, 1)), "latitude" REAL NULL, "longitude" REAL NULL, "accuracy_meters" REAL NULL, "location_captured_at" INTEGER NULL, "plot_reference_position" TEXT NULL, "created_at" INTEGER NOT NULL, "updated_at" INTEGER NOT NULL, PRIMARY KEY ("id"), UNIQUE(plot_id, number));
PRAGMA user_version = 9;
