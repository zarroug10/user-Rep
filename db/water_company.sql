-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 14, 2024 at 06:50 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `water company`
--

-- --------------------------------------------------------

--
-- Table structure for table `feedbacks`
--

CREATE TABLE `feedbacks` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `value` int(11) NOT NULL CHECK (`value` >= 0 and `value` <= 5),
  `incidentId` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedbacks`
--

INSERT INTO `feedbacks` (`id`, `userId`, `value`, `incidentId`, `created_at`) VALUES
(1, 60, 4, 5, '2024-04-26 08:39:58'),
(2, 60, 3, 5, '2024-04-26 17:26:56'),
(3, 60, 1, 5, '2024-04-26 17:27:03'),
(4, 60, 4, 5, '2024-04-26 17:27:10'),
(5, 60, 1, 5, '2024-04-26 17:27:14'),
(6, 60, 5, 5, '2024-04-26 18:41:43'),
(7, 60, 5, 5, '2024-04-26 18:41:51'),
(8, 60, 5, 5, '2024-04-26 18:41:52'),
(9, 60, 5, 5, '2024-04-26 18:41:53'),
(10, 60, 3, 2, '2024-04-26 18:59:21'),
(11, 60, 4, 2, '2024-04-26 18:59:34'),
(12, 60, 2, 2, '2024-04-26 18:59:40'),
(13, 60, 5, 2, '2024-04-26 18:59:48'),
(14, 4, 5, 1, '2024-05-04 22:45:55'),
(15, 4, 3, 1, '2024-05-04 22:46:02'),
(16, 4, 1, 1, '2024-05-04 22:46:06'),
(17, 4, 4, 1, '2024-05-04 22:46:10');

-- --------------------------------------------------------

--
-- Table structure for table `incidents`
--

CREATE TABLE `incidents` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `media` varchar(255) DEFAULT NULL,
  `status` enum('reported','assigned','in_progress','resolved') DEFAULT 'reported',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `userId` int(11) DEFAULT NULL,
  `teamId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `incidents`
--

INSERT INTO `incidents` (`id`, `title`, `description`, `location`, `latitude`, `longitude`, `media`, `status`, `created_at`, `updated_at`, `userId`, `teamId`) VALUES
(1, 'Water emergency', 'There is a water leak in the basement.', 'ibni ali', 33.87620700, 7.92490100, '1708020169440-RSI9.jpg', 'resolved', '2024-03-07 21:55:11', '2024-05-04 22:44:23', 48, 4),
(2, 'Water Leak', 'There is a water leak in the basement.', 'Ward Naam', 33.87620700, 7.91490100, '1708020169440-RSI9.jpg', 'resolved', '2024-03-07 21:57:18', '2024-04-26 18:58:43', 50, 7),
(3, 'Damaged pipe', 'There is a water leak', 'shourfa', 33.87620700, 7.89490100, 'Angular_full_color_logo.svg.png', 'assigned', '2024-03-11 16:47:15', '2024-05-05 04:03:52', 48, 4),
(4, 'Damaged pipe', 'Damaged pip', 'Gataaya', 33.87620700, 7.90490100, 'Bard_Generated_Image.png', 'reported', '2024-03-12 06:02:07', '2024-03-16 04:56:35', 50, NULL),
(5, 'damaged pip', 'hello ', 'Zawya', 33.87570700, 7.88490100, '1708023047463-69805_Little_Nightmares_II.jpg', 'assigned', '2024-03-15 05:03:39', '2024-05-05 04:04:02', 4, 5),
(8, 'damaged pip', 'hello ', 'Zawya', 33.87570700, 7.88490100, '1708023047463-69805_Little_Nightmares_II.jpg', 'in_progress', '2024-03-15 05:03:39', '2024-03-16 11:29:26', 4, NULL),
(9, 'damaged pip', 'hello this a an emergency ', 'ibni ali', 33.87568800, 7.88489900, '1711553430459-smiling-mature-couple-meeting-bank-600nw-2259811269.jpg', 'in_progress', '2024-03-27 15:30:30', '2024-05-05 04:04:15', 4, 7);

-- --------------------------------------------------------

--
-- Table structure for table `messagedeletions`
--

CREATE TABLE `messagedeletions` (
  `id` int(11) NOT NULL,
  `message_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `deletion_time` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messagedeletions`
--

INSERT INTO `messagedeletions` (`id`, `message_id`, `user_id`, `deletion_time`) VALUES
(1, 4, 60, '2024-05-01 16:44:58'),
(2, 5, 60, '2024-05-01 17:24:32');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `location` text NOT NULL,
  `messageContent` text NOT NULL,
  `userId` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `location`, `messageContent`, `userId`, `created_at`) VALUES
(1, 'Zawya', 'this is a test message to peaple living in zawya .', 4, '2024-04-26 08:28:38'),
(2, 'Nafta', 'this is a message ffor peaple living in nafta', 4, '2024-04-26 08:29:36'),
(4, 'Nafta', 'this messageContent will be deleted for a specifc user', 60, '2024-05-01 16:34:48'),
(5, 'Nafta', 'this messageContent will also be deleted for a specifc user', 4, '2024-05-01 17:23:33');

-- --------------------------------------------------------

--
-- Table structure for table `repairreports`
--

CREATE TABLE `repairreports` (
  `id` int(11) NOT NULL,
  `description` text NOT NULL,
  `duration` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `repairreports`
--

INSERT INTO `repairreports` (`id`, `description`, `duration`, `userId`, `created_at`) VALUES
(1, 'Fixed leaking pipe', 60, 48, '2024-03-12 04:58:56'),
(2, 'Fixed leaking pipe', 60, 50, '2024-03-12 05:01:11');

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `incidentId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`id`, `name`, `createdAt`, `updatedAt`, `incidentId`) VALUES
(5, 'Team Alpha', '2024-03-21 10:29:36', '2024-03-21 10:29:36', NULL),
(6, 'Team Omega', '2024-03-22 08:41:36', '2024-03-22 08:41:36', NULL),
(7, 'Team Omega', '2024-03-22 08:42:13', '2024-03-22 08:42:13', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `userType` enum('client','technician','chief','Admin') DEFAULT 'client',
  `tel` varchar(255) NOT NULL,
  `cin` varchar(255) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `isBanned` tinyint(1) DEFAULT 0,
  `teamId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `location`, `userType`, `tel`, `cin`, `createdAt`, `updatedAt`, `isBanned`, `teamId`) VALUES
(1, 'example_user', 'user@example.com', '$2b$10$y.FPLwGz7xFPJ2q6HGP1P.GPz5EoKtGpd48wbp5zgPYpWnCY43jlG', 'example_location', 'client', '12345678', '12345678', '2024-03-02 18:55:17', '2024-03-02 18:55:17', 0, NULL),
(2, 'client2', 'client2@example.com', '$2b$10$cg5y2izCsqA0KqujbC/MHOEKZaofc0XP9TAMIDmsjaTRsFEroGvHi', 'Location2', 'client', '23456789', '23456789', '2024-03-02 18:56:23', '2024-03-02 18:56:23', 0, NULL),
(3, 'client3', 'client3@example.com', '$2b$10$7.hL9AaHa1AlEvSghZdmQucmnK5YVhY.3aa6wEG9pj.DQPz.qGIVi', 'Location3', 'client', '34567890', '34567890', '2024-03-02 18:56:34', '2024-03-02 18:56:34', 0, NULL),
(4, 'chief', 'chief1@example.com', '$2b$10$SiIw75qzxoAHhtwCgWYF6OOYoBWVDF0M4rzQJV9sdvW.gYtCApGJO', 'Zawya', 'chief', '45678901', '09723561', '2024-03-02 18:56:46', '2024-03-23 12:34:51', 0, NULL),
(5, 'admin1', 'admin1@example.com', '$2b$10$.6o6Onnorxg1yS5QoumHkOy7HdA78eg.vVv7KA6/jzH1Rsca95E9O', 'Admin Location', 'Admin', '56789012', '56789012', '2024-03-02 18:57:00', '2024-03-02 18:57:00', 0, NULL),
(9, 'Sami Lazrag', 'SamiLazrag@example.com', '$2b$10$SGz4oCT/Xe0u4zAxU0VjmuJz8bboisMOInQY1NVsfJOfSki7T7dwO', 'Technician Location 1', 'technician', '00118823', '00118823', '2024-03-02 19:00:41', '2024-03-21 10:29:36', 0, NULL),
(12, 'layith', 'layith@gmail.com', '$2b$10$IslJhCj936LlxLDg9kn7MeA1m.VXyhr7/.Vf.Q6CoLG0d3iV4ZNtK', 'Zawya', 'technician', '09722131', '31256321', '2024-03-07 20:26:37', '2024-03-21 10:29:36', 0, NULL),
(16, 'Zarroug  abdelhafidh', 'zarrougabdelhafidh10@gmail.com', '$2b$10$/ZO/SgcPbX2mvskIIDu/J.qlH4Gz1.S3/qSU0Hljg9Kt58aX1eozW', 'Zawya', 'technician', '26143383', '09723562', '2024-03-09 03:29:14', '2024-03-21 10:29:36', 0, NULL),
(17, 'Salim Nawres', 'Salim@gmail.com', '$2b$10$umawvAjV.pLm9mirJShGF.URtxxWWJKbOgfxZ38ufrOU7WRETeJE.', 'Nafta', 'technician', '20154231', '22165341', '2024-03-09 21:06:47', '2024-03-22 08:42:14', 0, NULL),
(48, 'salim', 'salim@example.com', '$2b$10$DT92lmTUN7O266MJUHSjgOM6OxuBIm6dFPOEwG9pXonMND5MC7nju', 'Zawya', 'client', '22102965', '22102965', '2024-03-11 16:15:10', '2024-03-11 16:15:10', 0, NULL),
(50, 'Hafa', 'Hafa@example.com', '$2b$10$kxPyRYjQSg6hkm3z8IINLOsAd9kXXlQyy5qO/6uPAZBYhKAsgMB86', 'Location', 'client', '09700561', '09700561', '2024-03-12 05:00:21', '2024-03-12 05:00:21', 0, NULL),
(51, 'youcif zarroug', 'youcif@gmail.com', '$2b$10$wSlTiNjPy283ItSO9DZaGeAiMJDp4QbaApgxNhXgXMKI66LFkg0Vi', 'Nafta', 'technician', '20154555', '22215222', '2024-03-13 04:36:38', '2024-03-22 08:42:14', 0, NULL),
(52, 'salim', 'salim22@example.com', '$2b$10$.rkL7CVJ0aTMbcJ9xu4UgO8w15bgAY9jfq/hZjQfmXKJrwzboNPR.', 'Location', 'client', '33114764', '33114764', '2024-03-13 05:13:23', '2024-03-13 05:13:23', 0, NULL),
(56, 'Yazan', 'Yazan@gmail.com', '$2b$10$OysgL9Q3BE2Vb4GYn165yONy8Z872I/qMyeNrbxb/.9oCzJaWue32', 'Tunis', 'technician', '20154123', '22215123', '2024-03-18 12:34:55', '2024-03-22 08:42:14', 0, NULL),
(59, 'haithem ben salem', 'haithem@gmail.com', '$2b$10$XYHCQYm6qjAsm7GKncGKU.ejRlkb3/0JpZVUzN3rIbxE3B37cHu8i', 'Nafta', 'technician', '09865123', '09865123', '2024-03-18 12:46:07', '2024-03-18 12:46:07', 0, NULL),
(60, 'louay', 'louay@gmail.com', '$2b$10$W0rxk.0sa/o7AwS/QwYNs.G9zKp/g/9pev5LMiHZBjajmk7zXVk8u', 'Nafta', 'client', '10066213', '10066213', '2024-03-28 16:26:52', '2024-03-28 16:26:52', 0, NULL),
(108, 'naim', 'naim@gmail.com', '$2b$10$YJj5ModgbDRII/r4DcFEAu0Wk0m8nvkO1zUGbjmu2sjSrgl8i3Z/C', 'Nafta', 'client', '77777777', '77777777', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 0, NULL),
(109, 'lamine Touta', 'Lamine@gmaill.com', '$2b$10$uhfc34aE/uj86WPXK1WnYugJ./ZH5AeyvDsp7nHO5fm2oOtI9rndq', 'Gataaya', 'client', '22106578', '22106578', '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `feedbacks`
--
ALTER TABLE `feedbacks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`),
  ADD KEY `incidentId` (`incidentId`);

--
-- Indexes for table `incidents`
--
ALTER TABLE `incidents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_userId` (`userId`);

--
-- Indexes for table `messagedeletions`
--
ALTER TABLE `messagedeletions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `message_id` (`message_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `repairreports`
--
ALTER TABLE `repairreports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `tel` (`tel`),
  ADD UNIQUE KEY `cin` (`cin`),
  ADD UNIQUE KEY `email_2` (`email`),
  ADD UNIQUE KEY `tel_2` (`tel`),
  ADD UNIQUE KEY `cin_2` (`cin`),
  ADD UNIQUE KEY `email_3` (`email`),
  ADD UNIQUE KEY `tel_3` (`tel`),
  ADD UNIQUE KEY `cin_3` (`cin`),
  ADD UNIQUE KEY `email_4` (`email`),
  ADD UNIQUE KEY `tel_4` (`tel`),
  ADD UNIQUE KEY `cin_4` (`cin`),
  ADD UNIQUE KEY `email_5` (`email`),
  ADD UNIQUE KEY `tel_5` (`tel`),
  ADD UNIQUE KEY `cin_5` (`cin`),
  ADD UNIQUE KEY `email_6` (`email`),
  ADD UNIQUE KEY `tel_6` (`tel`),
  ADD UNIQUE KEY `cin_6` (`cin`),
  ADD UNIQUE KEY `email_7` (`email`),
  ADD UNIQUE KEY `tel_7` (`tel`),
  ADD UNIQUE KEY `cin_7` (`cin`),
  ADD KEY `teamId` (`teamId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `feedbacks`
--
ALTER TABLE `feedbacks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `incidents`
--
ALTER TABLE `incidents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `messagedeletions`
--
ALTER TABLE `messagedeletions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `repairreports`
--
ALTER TABLE `repairreports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `teams`
--
ALTER TABLE `teams`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `feedbacks`
--
ALTER TABLE `feedbacks`
  ADD CONSTRAINT `feedbacks_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `feedbacks_ibfk_2` FOREIGN KEY (`incidentId`) REFERENCES `incidents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `incidents`
--
ALTER TABLE `incidents`
  ADD CONSTRAINT `fk_userId` FOREIGN KEY (`userId`) REFERENCES `users` (`id`);

--
-- Constraints for table `messagedeletions`
--
ALTER TABLE `messagedeletions`
  ADD CONSTRAINT `messagedeletions_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`),
  ADD CONSTRAINT `messagedeletions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `repairreports`
--
ALTER TABLE `repairreports`
  ADD CONSTRAINT `repairreports_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `users` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `Users_teamId_foreign_idx` FOREIGN KEY (`teamId`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`teamId`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `users_ibfk_2` FOREIGN KEY (`teamId`) REFERENCES `teams` (`id`),
  ADD CONSTRAINT `users_ibfk_3` FOREIGN KEY (`teamId`) REFERENCES `teams` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
