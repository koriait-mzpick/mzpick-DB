-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mzpick
-- -----------------------------------------------------
-- 부산 코리아 아이티 아카데미 국비 과정 팀프로젝트 mzpick 웹 사이트 데이버베이스 ERD 모델 명세서

-- -----------------------------------------------------
-- Schema mzpick
--
-- 부산 코리아 아이티 아카데미 국비 과정 팀프로젝트 mzpick 웹 사이트 데이버베이스 ERD 모델 명세서
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mzpick` DEFAULT CHARACTER SET utf8 ;
USE `mzpick` ;

-- -----------------------------------------------------
-- Table `mzpick`.`tel_auth_number`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`tel_auth_number` (
  `tel_number` VARCHAR(11) NOT NULL COMMENT '사용자 전화번호\n',
  `auth_number` VARCHAR(6) NOT NULL COMMENT '사용자 전화번호에 해당하는 인증번호 6자리 ',
  PRIMARY KEY (`tel_number`))
ENGINE = InnoDB
COMMENT = '사용자 회원가입시 전화번호 인증에 필요한 전화번호 및 인증번호 저장 테이블\n';


-- -----------------------------------------------------
-- Table `mzpick`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`user` (
  `user_id` VARCHAR(20) NOT NULL COMMENT 'Mzpick 사용자 아이디',
  `password` VARCHAR(255) NOT NULL COMMENT 'Mzpick 웹사이트 사용자 비밀번호\n',
  `name` VARCHAR(20) NOT NULL COMMENT 'Mzpick 웹사이트 사용자 이름',
  `tel_number` VARCHAR(11) NOT NULL COMMENT 'Mzpick 웹사이트 사용자 전화번호 인증 -> tel_number_auth랑 FK\n',
  `join_path` VARCHAR(5) NOT NULL DEFAULT 'HOME' COMMENT '카카오 / 네이버 / 홈 사용자 회원가입 경로',
  `sns_id` VARCHAR(255) NULL DEFAULT NULL COMMENT '사용자 간편 가입 아이디\n',
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  INDEX `tel_auth_number_idx` (`tel_number` ASC) VISIBLE,
  UNIQUE INDEX `tel_number_UNIQUE` (`tel_number` ASC) VISIBLE,
  CONSTRAINT `tel_auth_number_fk`
    FOREIGN KEY (`tel_number`)
    REFERENCES `mzpick`.`tel_auth_number` (`tel_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Mzpick 웹사이트 가입된 유저 테이블\n';


-- -----------------------------------------------------
-- Table `mzpick`.`travel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel` (
  `travel_number` INT NOT NULL AUTO_INCREMENT COMMENT '여행 게시판 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '게시글 작성자 아이디\n',
  `travel_title` VARCHAR(100) NOT NULL COMMENT '게시글 제목\n',
  `travel_location` VARCHAR(100) NOT NULL COMMENT '특별 자치시 / 도 등',
  `travel_content` TEXT NOT NULL COMMENT '여행 게시글 내용',
  `travel_view_count` INT NOT NULL DEFAULT 0 COMMENT '여행 게시판 조회수',
  `travel_date` DATE NOT NULL COMMENT '여행 게시판 작성 일자',
  PRIMARY KEY (`travel_number`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '여행지 게시판 게시글';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_photo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_photo` (
  `travel_photo_number` INT NOT NULL AUTO_INCREMENT COMMENT '임의의 번호',
  `travel_number` INT NOT NULL COMMENT '여행 게시판 번호',
  `travel_photo_link` TEXT NOT NULL COMMENT '여행 게시판 사진 링크 컬럼',
  PRIMARY KEY (`travel_photo_number`),
  INDEX `travel_board_photo_idx` (`travel_number` ASC) VISIBLE,
  CONSTRAINT `travel_photo_number_fk`
    FOREIGN KEY (`travel_number`)
    REFERENCES `mzpick`.`travel` (`travel_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '여행 게시판 참조 사진 링크';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_hashtag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_hashtag` (
  `travel_hashtag_number` INT NOT NULL AUTO_INCREMENT COMMENT '임의의 번호',
  `travel_number` INT NOT NULL COMMENT '여행 게시판 보드 넘버',
  `travel_hashtag_content` VARCHAR(100) NOT NULL COMMENT '여행 게시판 해당 게시글 해시태그',
  PRIMARY KEY (`travel_hashtag_number`),
  INDEX `travel_board_hashtag_idx` (`travel_number` ASC) VISIBLE,
  CONSTRAINT `travel_hashtag_number_fk`
    FOREIGN KEY (`travel_number`)
    REFERENCES `mzpick`.`travel` (`travel_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '여행 게시판 해시태그 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_comment` (
  `travel_comment_number` INT NOT NULL AUTO_INCREMENT COMMENT '해당 게시판 댓글 번호',
  `travel_number` INT NOT NULL COMMENT '여행 게시판 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '댓글 작성자 아이디',
  `travel_comment` TEXT NOT NULL COMMENT '여행 게시판 게시글 댓글',
  PRIMARY KEY (`travel_comment_number`),
  INDEX `travel_board_comment_idx` (`travel_number` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_comment_number_fk`
    FOREIGN KEY (`travel_number`)
    REFERENCES `mzpick`.`travel` (`travel_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_comment_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '여행 게시판 댓글 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_like` (
  `travel_number` INT NOT NULL COMMENT '여행 게시판 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '유저 아이디\n',
  PRIMARY KEY (`user_id`, `travel_number`),
  CONSTRAINT `travel_like_number_fk`
    FOREIGN KEY (`travel_number`)
    REFERENCES `mzpick`.`travel` (`travel_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_like_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`travel_food`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_food` (
  `travel_food_number` INT NOT NULL AUTO_INCREMENT COMMENT '여행 외식(맛집) 게시판 번호\n',
  `user_id` VARCHAR(20) NOT NULL COMMENT '게시물 작성자 아이디',
  `travel_food_title` VARCHAR(100) NOT NULL COMMENT '여행 외식 제목\n',
  `travel_location` VARCHAR(100) NOT NULL COMMENT '특별 자치시 / 도 등 대 주소',
  `travel_food_content` TEXT NOT NULL COMMENT '여행 외식 게시판 내용\n',
  `travel_food_view_count` INT NOT NULL DEFAULT 0 COMMENT '여행 음식 게시판 조회수\n',
  `travel_food_date` DATE NOT NULL COMMENT '여행 외식 게시판 업로드 날짜\n',
  PRIMARY KEY (`travel_food_number`),
  INDEX `travel_food_user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_food_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '여행 외식(푸드) 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_food_hashtag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_food_hashtag` (
  `travel_food_hashtag_number` INT NOT NULL AUTO_INCREMENT COMMENT '임의의 넘버',
  `travel_food_number` INT NOT NULL COMMENT '여행 외식 게시글 번호',
  `travel_food_hashtag_content` VARCHAR(100) NOT NULL COMMENT '여행 게시판 해당 게시글 해시태그',
  PRIMARY KEY (`travel_food_hashtag_number`),
  INDEX `travel_food_hashtag_numeber_idx` (`travel_food_number` ASC) VISIBLE,
  CONSTRAINT `travel_food_hashtag_number_fk`
    FOREIGN KEY (`travel_food_number`)
    REFERENCES `mzpick`.`travel_food` (`travel_food_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '여행 게시판 해시태그 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_food_photo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_food_photo` (
  `travel_food_photo_number` INT NOT NULL AUTO_INCREMENT COMMENT '임의의 번호',
  `travel_food_number` INT NOT NULL COMMENT '여행 게시글 번호',
  `travel_food_photo_link` TEXT NOT NULL COMMENT '여행 게시판 사진 링크 컬럼',
  PRIMARY KEY (`travel_food_photo_number`),
  INDEX `travel_food_board_number_idx` (`travel_food_number` ASC) VISIBLE,
  CONSTRAINT `travel_food_photo_number_fk`
    FOREIGN KEY (`travel_food_number`)
    REFERENCES `mzpick`.`travel_food` (`travel_food_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '여행 게시판 참조 사진 링크';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_food_comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_food_comment` (
  `travel_food_comment_number` INT NOT NULL AUTO_INCREMENT COMMENT '여행 외식 댓글 번호\n',
  `travel_food_number` INT NOT NULL COMMENT '여행 외식게시글 번호',
  `user_id` VARCHAR(45) NOT NULL COMMENT '여행 외식 댓글 작성 사용자 아이디',
  `travel_food_comment` TEXT NOT NULL COMMENT '여행 게시판 게시글 댓글',
  PRIMARY KEY (`travel_food_comment_number`),
  INDEX `travel_food_board_number_idx` (`travel_food_number` ASC) VISIBLE,
  INDEX `travel_food_userid_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_food_comment_number_fk`
    FOREIGN KEY (`travel_food_number`)
    REFERENCES `mzpick`.`travel_food` (`travel_food_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_food_comment_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '여행 외식 게시판 댓글 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_food_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_food_like` (
  `travel_food_number` INT NOT NULL COMMENT '여행 게시판 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '사용자 아이디',
  PRIMARY KEY (`user_id`, `travel_food_number`),
  INDEX `traver_food_like_user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `traver_food_like_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `traver_food_like_number_fk`
    FOREIGN KEY (`travel_food_number`)
    REFERENCES `mzpick`.`travel_food` (`travel_food_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`travel_stay`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_stay` (
  `travel_stay_number` INT NOT NULL AUTO_INCREMENT COMMENT '여행 숙박 게시판 번호\n',
  `user_id` VARCHAR(20) NOT NULL COMMENT '게시물 작성자 아이디',
  `travel_stay_title` VARCHAR(100) NOT NULL COMMENT '여행 숙박 제목\n',
  `travel_location` VARCHAR(50) NOT NULL COMMENT '특별 자치시 / 도 등',
  `travel_stay_content` TEXT NOT NULL COMMENT '여행 숙박 게시판 내용\n',
  `travel_stay_view_count` INT NOT NULL DEFAULT 0 COMMENT '여행 숙박 게시판 조회수\n',
  `travel_stay_date` DATE NOT NULL COMMENT '여행 숙박 게시판 업로드 날짜\n',
  PRIMARY KEY (`travel_stay_number`),
  INDEX `travel_stay_userid_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_stay_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '여행 숙박 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_stay_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_stay_like` (
  `travel_stay_number` INT NOT NULL COMMENT '여행 숙박 게시글 번호',
  `user_id` VARCHAR(45) NOT NULL COMMENT '여행 게시글 좋아요 유저',
  INDEX `travel_stay_like_userid_idx` (`user_id` ASC) VISIBLE,
  PRIMARY KEY (`user_id`, `travel_stay_number`),
  CONSTRAINT `travel_stay_like_number_fk`
    FOREIGN KEY (`travel_stay_number`)
    REFERENCES `mzpick`.`travel_stay` (`travel_stay_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_stay_like_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`travel_stay_photo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_stay_photo` (
  `travel_stay_photo_number` INT NOT NULL AUTO_INCREMENT COMMENT '임의의 번호',
  `travel_stay_number` INT NOT NULL COMMENT '여행 숙박 게시글 번호',
  `travel_stay_photo_link` TEXT NOT NULL COMMENT '여행 게시판 사진 링크 컬럼',
  PRIMARY KEY (`travel_stay_photo_number`),
  INDEX `travel_stay_photo_board_number_idx` (`travel_stay_number` ASC) VISIBLE,
  CONSTRAINT `travel_stay_photo_number`
    FOREIGN KEY (`travel_stay_number`)
    REFERENCES `mzpick`.`travel_stay` (`travel_stay_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`travel_stay_hashtag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_stay_hashtag` (
  `travel_stay_hashtag_number` INT NOT NULL AUTO_INCREMENT COMMENT '임의의 넘버',
  `tavel_stay_number` INT NOT NULL,
  `travel_stay_hashtag_content` VARCHAR(100) NOT NULL COMMENT '여행 게시판 해당 게시글 해시태그',
  PRIMARY KEY (`travel_stay_hashtag_number`),
  INDEX `travel_stay_board_number_idx` (`tavel_stay_number` ASC) VISIBLE,
  CONSTRAINT `travel_stay_hashtag_number_fk`
    FOREIGN KEY (`tavel_stay_number`)
    REFERENCES `mzpick`.`travel_stay` (`travel_stay_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '여행 게시판 해시태그 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_stay_comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_stay_comment` (
  `travel_stay_comment_number` INT NOT NULL AUTO_INCREMENT COMMENT '여행 숙박 댓글 번호',
  `user_id` VARCHAR(20) NOT NULL,
  `travel_stay_number` INT NOT NULL,
  `travel_stay_comment` TEXT NOT NULL COMMENT '여행 게시판 게시글 댓글',
  PRIMARY KEY (`travel_stay_comment_number`),
  INDEX `travel_stay_board_number_idx` (`travel_stay_number` ASC) VISIBLE,
  INDEX `travel_stay_comment_userid_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_stay_comment_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_stay_comment_number_fk`
    FOREIGN KEY (`travel_stay_number`)
    REFERENCES `mzpick`.`travel_stay` (`travel_stay_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '여행 게시판 댓글 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_stay_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_stay_category` (
  `travel_stay_category_number` INT NOT NULL AUTO_INCREMENT,
  `travel_stay_number` INT NOT NULL,
  `travel_stay_category_content` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`travel_stay_category_number`),
  INDEX `travel_stay_board_number_idx` (`travel_stay_number` ASC) VISIBLE,
  CONSTRAINT `travel_stay_category_number_fk`
    FOREIGN KEY (`travel_stay_number`)
    REFERENCES `mzpick`.`travel_stay` (`travel_stay_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`travel_cafe`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_cafe` (
  `travel_cafe_number` INT NOT NULL AUTO_INCREMENT COMMENT '여행 외식 (카페) 게시판 번호\n',
  `user_id` VARCHAR(20) NOT NULL COMMENT '게시물 작성자 아이디',
  `travel_cafe_category` INT NOT NULL COMMENT '여행 카페 카테고리 종류',
  `travel_cafe_title` VARCHAR(100) NOT NULL COMMENT '여행 외식(카페) 제목\n',
  `travel_location` VARCHAR(100) NOT NULL COMMENT '특별자치시 / 도 등',
  `travel_cate_content` TEXT NOT NULL COMMENT '여행 카페 게시판 내용\n',
  `travel_cefe_view_count` INT NOT NULL DEFAULT 0 COMMENT '여행 카페 게시판 조회수\n',
  `travel_cate_date` DATE NOT NULL COMMENT '여행 카페 게시판 업로드 날짜\n',
  PRIMARY KEY (`travel_cafe_number`),
  INDEX `travel_user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_cafe_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '여행  카페 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_cafe_photo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_cafe_photo` (
  `travel_cafe_photo_number` INT NOT NULL AUTO_INCREMENT COMMENT '임의의 번호',
  `travel_cafe_number` INT NOT NULL COMMENT '여행 카페 게시글 번호',
  `travel_cafe_photo_link` TEXT NOT NULL COMMENT '여행 카페 게시판 사진 링크 컬럼',
  PRIMARY KEY (`travel_cafe_photo_number`),
  INDEX `travel_cafe_board_number_idx` (`travel_cafe_number` ASC) VISIBLE,
  CONSTRAINT `travel_cafe_photo_number_fk`
    FOREIGN KEY (`travel_cafe_number`)
    REFERENCES `mzpick`.`travel_cafe` (`travel_cafe_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '여행 게시판 참조 사진 링크';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_cafe_hashtag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_cafe_hashtag` (
  `travel_cafe_hashtag_number` INT NOT NULL AUTO_INCREMENT COMMENT '임의의 넘버',
  `travel_cafe_number` INT NOT NULL COMMENT '게시글 번호',
  `travel_cafe_hashtag_content` VARCHAR(100) NOT NULL COMMENT '여행 게시판 해당 게시글 해시태그',
  PRIMARY KEY (`travel_cafe_hashtag_number`),
  INDEX `travel_cafe_number_idx` (`travel_cafe_number` ASC) VISIBLE,
  CONSTRAINT `travel_cafe_hashtag_number_fk`
    FOREIGN KEY (`travel_cafe_number`)
    REFERENCES `mzpick`.`travel_cafe` (`travel_cafe_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '여행 게시판 해시태그 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_cafe_comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_cafe_comment` (
  `travel_cafe_comment_number` INT NOT NULL AUTO_INCREMENT COMMENT '여행지 카페 댓글 번호\n',
  `user_id` VARCHAR(45) NOT NULL,
  `travel_cafe_number` INT NOT NULL,
  `travel_cafe_comment` TEXT NOT NULL COMMENT '여행 게시판 게시글 댓글',
  PRIMARY KEY (`travel_cafe_comment_number`),
  INDEX `travel_cafe_board_number_idx` (`travel_cafe_number` ASC) VISIBLE,
  INDEX `travel_cafe_usreid_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_cafe_comment_number_fk`
    FOREIGN KEY (`travel_cafe_number`)
    REFERENCES `mzpick`.`travel_cafe` (`travel_cafe_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_cafe_comment_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '여행 게시판 댓글 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_cafe_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_cafe_like` (
  `travel_cafe_number` INT NOT NULL COMMENT '여행 카페 게시글 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '좋아요 누른 사용자 아이디',
  PRIMARY KEY (`user_id`, `travel_cafe_number`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_cafe_like_number_fk`
    FOREIGN KEY (`travel_cafe_number`)
    REFERENCES `mzpick`.`travel_cafe` (`travel_cafe_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_cafe_like_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`travel_cafe_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_cafe_category` (
  `travel_cafe_category_number` INT NOT NULL AUTO_INCREMENT COMMENT '임의의 번호',
  `travel_cafe_number` INT NOT NULL COMMENT '여행 카페 게시글 번호',
  `travel_cafe_category_content` VARCHAR(100) NOT NULL COMMENT '여행지 카페 게시글 카테고리',
  PRIMARY KEY (`travel_cafe_category_number`),
  INDEX `travel_cafe_board_number_idx` (`travel_cafe_number` ASC) VISIBLE,
  CONSTRAINT `travel_cafe_category_number_fk`
    FOREIGN KEY (`travel_cafe_number`)
    REFERENCES `mzpick`.`travel_cafe` (`travel_cafe_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = '여행 카페 카테고리\n';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_vote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_vote` (
  `travel_vote_number` INT NOT NULL AUTO_INCREMENT COMMENT '여행 투표 게시판 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '여행 투표 작성자 아이디',
  `travel_vote_title` VARCHAR(50) NOT NULL COMMENT '여행 투표 게시판 제목',
  `travel_vote_photo_1` TEXT NULL DEFAULT NULL COMMENT '여행 게시판 투표 사진1',
  `travel_vote_photo_2` TEXT NULL DEFAULT NULL COMMENT '여행 게시판 투표 사진2',
  `travel_vote_choice_1` VARCHAR(50) NOT NULL COMMENT '여행 투표 게시판 선택 항목 1',
  `travel_vote_choice_2` VARCHAR(50) NOT NULL COMMENT '여행 게시판 투표 항목 2',
  `travel_vote_date` DATE NOT NULL COMMENT '여행 투표 게시판 업로드 날짜',
  PRIMARY KEY (`travel_vote_number`),
  INDEX `travel_vote_user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_vote_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '여행 관련 투표 페이지\n';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_vote_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_vote_result` (
  `user_id` VARCHAR(20) NOT NULL COMMENT '투표한 유저 아이디',
  `travel_vote_number` INT NOT NULL COMMENT '여행 투표 게시판 번호',
  `travel_vote_result_choice` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`user_id`, `travel_vote_number`),
  CONSTRAINT `travel_vote_result_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_vote_result_number_fk`
    FOREIGN KEY (`travel_vote_number`)
    REFERENCES `mzpick`.`travel_vote` (`travel_vote_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '투표 결과 집계\n';


-- -----------------------------------------------------
-- Table `mzpick`.`popular_food`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`popular_food` (
  `popular_food_number` INT NOT NULL AUTO_INCREMENT COMMENT '리스트 유행 음식 번호',
  `popular_food_rank` INT NOT NULL COMMENT '유행음식 랭킹',
  `popular_food_photo_link` TEXT NOT NULL COMMENT '유행 음식 사진 ',
  `popular_food_name` VARCHAR(45) NOT NULL COMMENT '유행 음식 이름',
  `popular_food_description` TEXT NOT NULL COMMENT '유행 음식 설명',
  PRIMARY KEY (`popular_food_number`))
ENGINE = InnoDB
COMMENT = '최신 유행 음식 TOP20\n';


-- -----------------------------------------------------
-- Table `mzpick`.`fashion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`fashion` (
  `fashion_number` INT NOT NULL AUTO_INCREMENT COMMENT '패션 게시판 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '작성자 아이디',
  `fashion_title` VARCHAR(100) NOT NULL COMMENT '패션 게시글 제목\n',
  `fashion_content` TEXT NOT NULL COMMENT '패션 게시글 내용',
  `fashion_total_price` INT NOT NULL DEFAULT 0 COMMENT '패션 옷 가격',
  `fashion_view_count` INT NOT NULL DEFAULT 0 COMMENT '패션 게시판 조회수',
  `fashion_date` DATE NOT NULL COMMENT '패션 게시판 작성 일자',
  PRIMARY KEY (`fashion_number`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fashion_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '패션 게시글\n';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_save`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_save` (
  `travel_number` INT NOT NULL COMMENT '저장할 게시글 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '저장한 사용자 아이디',
  PRIMARY KEY (`user_id`, `travel_number`),
  INDEX `travel_user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_save_number_fk`
    FOREIGN KEY (`travel_number`)
    REFERENCES `mzpick`.`travel` (`travel_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `travel_save_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '여행 게시물 저장\n';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_food_save`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_food_save` (
  `travel_food_number` INT NOT NULL,
  `user_id` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`user_id`, `travel_food_number`),
  INDEX `travel_food_user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_food_save_number_fk`
    FOREIGN KEY (`travel_food_number`)
    REFERENCES `mzpick`.`travel_food` (`travel_food_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_food_save_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`travel_stay_save`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_stay_save` (
  `travel_stay_number` INT NOT NULL COMMENT '여행지 숙박 게시글 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '작성자 아이디',
  PRIMARY KEY (`user_id`, `travel_stay_number`),
  INDEX `travel_user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_stay_save_number_fk`
    FOREIGN KEY (`travel_stay_number`)
    REFERENCES `mzpick`.`travel_stay` (`travel_stay_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_stay_save_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`travel_cafe_save`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_cafe_save` (
  `travel_cafe_number` INT NOT NULL COMMENT '여행 게시판 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '여행 카페  저장 사용자 아이디',
  PRIMARY KEY (`user_id`, `travel_cafe_number`),
  INDEX `travel_user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `travel_cafe_save_number_fk`
    FOREIGN KEY (`travel_cafe_number`)
    REFERENCES `mzpick`.`travel_cafe` (`travel_cafe_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_cafe_save_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`fashion_comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`fashion_comment` (
  `fashion_comment_number` INT NOT NULL AUTO_INCREMENT COMMENT '임의의 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '여행 게시판 게시글 댓글',
  `fashion_number` INT NOT NULL,
  `fashion_comment` TEXT NOT NULL,
  PRIMARY KEY (`fashion_comment_number`),
  INDEX `fation_board_number_idx` (`fashion_number` ASC) VISIBLE,
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fashion_comment_number_fk`
    FOREIGN KEY (`fashion_number`)
    REFERENCES `mzpick`.`fashion` (`fashion_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fashion_comment_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '여행 게시판 댓글 테이블';


-- -----------------------------------------------------
-- Table `mzpick`.`fashion_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`fashion_like` (
  `user_id` VARCHAR(20) NOT NULL COMMENT '좋아요 누른 유저 아이디',
  `fashion_number` INT NOT NULL COMMENT '패션 게시판 번호',
  PRIMARY KEY (`user_id`, `fashion_number`),
  INDEX `fation_board_number_idx` (`fashion_number` ASC) VISIBLE,
  CONSTRAINT `fashion_like_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fashion_like_number_fk`
    FOREIGN KEY (`fashion_number`)
    REFERENCES `mzpick`.`fashion` (`fashion_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`fashion_save`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`fashion_save` (
  `user_id` VARCHAR(20) NOT NULL COMMENT '저장한 유저 아이디',
  `fashion_number` INT NOT NULL COMMENT '패션 게시판 번호',
  PRIMARY KEY (`user_id`, `fashion_number`),
  INDEX `fation_board_number_idx` (`fashion_number` ASC) VISIBLE,
  CONSTRAINT `fashion_save_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fashion_save_number_fk`
    FOREIGN KEY (`fashion_number`)
    REFERENCES `mzpick`.`fashion` (`fashion_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '패션 저장';


-- -----------------------------------------------------
-- Table `mzpick`.`fashion_photo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`fashion_photo` (
  `fashion_photo_number` INT NOT NULL AUTO_INCREMENT,
  `fashion_number` INT NOT NULL COMMENT '게시판 번호',
  `fashion_photo_link` TEXT NOT NULL COMMENT '패션 게시판 사진',
  PRIMARY KEY (`fashion_photo_number`),
  INDEX `fation_board_number_idx` (`fashion_number` ASC) VISIBLE,
  CONSTRAINT `fashion_photo_number_fk`
    FOREIGN KEY (`fashion_number`)
    REFERENCES `mzpick`.`fashion` (`fashion_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`fashion_vote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`fashion_vote` (
  `fashion_vote_number` INT NOT NULL AUTO_INCREMENT COMMENT '패션 투표 게시글 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '투표 작성자 아이디',
  `fashion_vote_title` VARCHAR(45) NOT NULL COMMENT '패션 투표 제목',
  `fashion_vote_photo_1` TEXT NOT NULL COMMENT '패션 투표 사진1',
  `fashion_vote_photo_2` TEXT NOT NULL COMMENT '패션 투표 사진 2',
  `fashion_vote_choice_1` VARCHAR(50) NOT NULL COMMENT '패션 투표 선택항목 1',
  `fashion_vote_choice_2` VARCHAR(45) NOT NULL COMMENT '패션 투표 선택항목 2',
  `fashion_vote_date` DATE NOT NULL COMMENT '패션 투표 날짜',
  PRIMARY KEY (`fashion_vote_number`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fashion_vote_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`fashion_vote_result`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`fashion_vote_result` (
  `user_id` VARCHAR(20) NOT NULL COMMENT '패션 투표 유저 아이디',
  `fashion_vote_number` INT NOT NULL COMMENT '패션 투표 게시글 번호',
  `fashion_vote_result_choice` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`user_id`, `fashion_vote_number`),
  INDEX `fashion_vote_result_number_fk_idx` (`fashion_vote_number` ASC) VISIBLE,
  CONSTRAINT `fashion_vote_result_number_fk`
    FOREIGN KEY (`fashion_vote_number`)
    REFERENCES `mzpick`.`fashion_vote` (`fashion_vote_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fashion_vote_result_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`keyword`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`keyword` (
  `keyword_number` INT NOT NULL AUTO_INCREMENT COMMENT '키워드 카테고리 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '키워드 작성자 아이디',
  `keyword_content` VARCHAR(100) NOT NULL COMMENT '키워드 내용',
  `keyword_date` DATE NOT NULL COMMENT '키워드 업로드 날짜\n',
  PRIMARY KEY (`keyword_number`),
  INDEX `user_id_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `keyword_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mzpick`.`keyword_filtering`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`keyword_filtering` (
  `keyword_filtering_number` INT NOT NULL AUTO_INCREMENT COMMENT '키워드 필터링 번호',
  `filtering_keyword` VARCHAR(100) NOT NULL COMMENT '필터링 키워드',
  PRIMARY KEY (`keyword_filtering_number`))
ENGINE = InnoDB
COMMENT = '공통 게시판 비속어 제한\n';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_comment_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_comment_like` (
  `travel_comment_number` INT NOT NULL,
  `user_id` VARCHAR(20) NOT NULL COMMENT '댓글 좋아요 클릭 유저 아이디',
  PRIMARY KEY (`user_id`, `travel_comment_number`),
  CONSTRAINT `travel_comment_like_number_fk`
    FOREIGN KEY (`travel_comment_number`)
    REFERENCES `mzpick`.`travel_comment` (`travel_comment_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_comment_like_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = ' 여행 게시판 댓글 공감하기';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_cafe_comment_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_cafe_comment_like` (
  `travel_cafe_comment_number` INT NOT NULL COMMENT '여행지 카페 댓글 번호\n',
  `user_id` VARCHAR(20) NOT NULL COMMENT '댓글 좋아요 클릭 유저 아이디',
  PRIMARY KEY (`user_id`, `travel_cafe_comment_number`),
  CONSTRAINT `travel_cafe_comment_like_number_fk`
    FOREIGN KEY (`travel_cafe_comment_number`)
    REFERENCES `mzpick`.`travel_cafe_comment` (`travel_cafe_comment_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_cafe_comment_like_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = ' 여행 카페 게시판 댓글 공감하기';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_stay_comment_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_stay_comment_like` (
  `travel_stay_comment_number` INT NOT NULL COMMENT '여행지 카페 댓글 번호\n',
  `user_id` VARCHAR(20) NOT NULL COMMENT '댓글 좋아요 클릭 유저 아이디',
  PRIMARY KEY (`user_id`, `travel_stay_comment_number`),
  CONSTRAINT `travel_stay_comment_like_number_fk`
    FOREIGN KEY (`travel_stay_comment_number`)
    REFERENCES `mzpick`.`travel_stay_comment` (`travel_stay_comment_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_stay_comment_like_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = ' 여행 게시판 댓글 공감하기';


-- -----------------------------------------------------
-- Table `mzpick`.`travel_food_comment_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`travel_food_comment_like` (
  `travel_food_comment_number` INT NOT NULL COMMENT '여행지 카페 댓글 번호\n',
  `user_id` VARCHAR(20) NOT NULL COMMENT '댓글 좋아요 클릭 유저 아이디',
  PRIMARY KEY (`user_id`, `travel_food_comment_number`),
  CONSTRAINT `travel_food_comment_like_number_fk`
    FOREIGN KEY (`travel_food_comment_number`)
    REFERENCES `mzpick`.`travel_food_comment` (`travel_food_comment_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `travel_food_comment_like_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = ' 여행 외식 게시판 댓글 공감하기';


-- -----------------------------------------------------
-- Table `mzpick`.`fashion_comment_like`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`fashion_comment_like` (
  `fashion_comment_number` INT NOT NULL COMMENT '패션 게시글 댓글 번호',
  `user_id` VARCHAR(20) NOT NULL COMMENT '댓글 공감한 유저 아이디',
  PRIMARY KEY (`fashion_comment_number`, `user_id`),
  CONSTRAINT `fashion_comment_like_number_fk`
    FOREIGN KEY (`fashion_comment_number`)
    REFERENCES `mzpick`.`fashion_comment` (`fashion_comment_number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fashion_comment_like_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `mzpick`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '패션 댓글 공감하기';


-- -----------------------------------------------------
-- Table `mzpick`.`fashion_hashtag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mzpick`.`fashion_hashtag` (
  `fashion_hashtag_number` INT NOT NULL AUTO_INCREMENT,
  `fashion_number` INT NOT NULL,
  `fashion_hashtag_content` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`fashion_hashtag_number`),
  INDEX `fashion_hashtag_number_fk_idx` (`fashion_number` ASC) VISIBLE,
  CONSTRAINT `fashion_hashtag_number_fk`
    FOREIGN KEY (`fashion_number`)
    REFERENCES `mzpick`.`fashion` (`fashion_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '패션 해시태그	';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
