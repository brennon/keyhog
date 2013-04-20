CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "username" varchar(255), "email" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "first_name" varchar(255), "last_name" varchar(255));
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20130418175153');

INSERT INTO schema_migrations (version) VALUES ('20130418184414');