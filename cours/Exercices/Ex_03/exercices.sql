
ALTER TABLE compagnies
ADD COLUMN `status`ENUM('published', 'unpublished', 'draft')
DEFAULT 'unpublished';

