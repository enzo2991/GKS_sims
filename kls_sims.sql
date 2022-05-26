--
-- Structure de la table `user_sim`
--

CREATE TABLE `user_sim` (
  `id` int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `identifier` varchar(555) NOT NULL,
  `number` varchar(555) NOT NULL,
  `label` varchar(555) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;