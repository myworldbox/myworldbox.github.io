'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "e146d040209e8347753ab1ac0c92a2a4",
"assets/AssetManifest.bin.json": "0f0de662529c7c03029234b0a7012408",
"assets/assets/gif/1868d559": "b40a815917c7db4f55dd3bc9c79aa0db",
"assets/assets/gif/2457f753": "f73eca8a1837959e550cc44f0db67632",
"assets/assets/gif/24abddfe": "04919e2a62d6a614276d03336a2c8c9d",
"assets/assets/gif/28db7991": "f73eca8a1837959e550cc44f0db67632",
"assets/assets/gif/34dc9eed": "3a350f84d3d25603dc6739ddd46dfdd2",
"assets/assets/gif/3fbc2aaf": "3a350f84d3d25603dc6739ddd46dfdd2",
"assets/assets/gif/55cfe27c": "8ed6b6404244f6873c7f878c53829050",
"assets/assets/gif/585b2879": "04919e2a62d6a614276d03336a2c8c9d",
"assets/assets/gif/5a9ee2bb": "2ba8a71de0e7d7c718f2601ca5b3437e",
"assets/assets/gif/619df259": "802c000c53063668dc065d36dcc5f5ee",
"assets/assets/gif/640f862c": "2ba8a71de0e7d7c718f2601ca5b3437e",
"assets/assets/gif/65172021": "8ed6b6404244f6873c7f878c53829050",
"assets/assets/gif/66150ffc": "f73eca8a1837959e550cc44f0db67632",
"assets/assets/gif/67c9913b": "04919e2a62d6a614276d03336a2c8c9d",
"assets/assets/gif/694f84f2": "04919e2a62d6a614276d03336a2c8c9d",
"assets/assets/gif/6ce07afc": "2ba8a71de0e7d7c718f2601ca5b3437e",
"assets/assets/gif/700e7c16": "00fc06ed86e975b82f36f5c06b8fe59a",
"assets/assets/gif/7a0787d8": "802c000c53063668dc065d36dcc5f5ee",
"assets/assets/gif/80534509": "2ba8a71de0e7d7c718f2601ca5b3437e",
"assets/assets/gif/838c58b9": "00fc06ed86e975b82f36f5c06b8fe59a",
"assets/assets/gif/86a84e9d": "3a350f84d3d25603dc6739ddd46dfdd2",
"assets/assets/gif/880ac68a": "8ed6b6404244f6873c7f878c53829050",
"assets/assets/gif/88acc971": "b40a815917c7db4f55dd3bc9c79aa0db",
"assets/assets/gif/8c76a14b": "2ba8a71de0e7d7c718f2601ca5b3437e",
"assets/assets/gif/a62eb6ea": "04919e2a62d6a614276d03336a2c8c9d",
"assets/assets/gif/b8df1dfd": "b40a815917c7db4f55dd3bc9c79aa0db",
"assets/assets/gif/bd263fcc": "8ed6b6404244f6873c7f878c53829050",
"assets/assets/gif/book_fold_0.gif": "2ba8a71de0e7d7c718f2601ca5b3437e",
"assets/assets/gif/book_fold_1.gif": "3a350f84d3d25603dc6739ddd46dfdd2",
"assets/assets/gif/book_fold_2.gif": "b40a815917c7db4f55dd3bc9c79aa0db",
"assets/assets/gif/book_fold_3.gif": "f73eca8a1837959e550cc44f0db67632",
"assets/assets/gif/book_spire.gif": "04919e2a62d6a614276d03336a2c8c9d",
"assets/assets/gif/c11bbdf3": "802c000c53063668dc065d36dcc5f5ee",
"assets/assets/gif/c1d806aa": "3a350f84d3d25603dc6739ddd46dfdd2",
"assets/assets/gif/d37f5500": "2ba8a71de0e7d7c718f2601ca5b3437e",
"assets/assets/gif/d5879ebd": "8ed6b6404244f6873c7f878c53829050",
"assets/assets/gif/e4220da4": "3a350f84d3d25603dc6739ddd46dfdd2",
"assets/assets/gif/eb69092a": "f73eca8a1837959e550cc44f0db67632",
"assets/assets/gif/eb7f9b35": "802c000c53063668dc065d36dcc5f5ee",
"assets/assets/gif/ed6fe6e": "04919e2a62d6a614276d03336a2c8c9d",
"assets/assets/gif/efdfa4f0": "f73eca8a1837959e550cc44f0db67632",
"assets/assets/gif/f019e1e8": "802c000c53063668dc065d36dcc5f5ee",
"assets/assets/gif/f2bafd72": "04919e2a62d6a614276d03336a2c8c9d",
"assets/assets/gif/face_scan_0.gif": "802c000c53063668dc065d36dcc5f5ee",
"assets/assets/gif/face_scan_1.gif": "8ed6b6404244f6873c7f878c53829050",
"assets/assets/gif/ghost_run.gif": "00fc06ed86e975b82f36f5c06b8fe59a",
"assets/assets/html/25ea82b3": "9faa9f25eb41f662d7268f0f37a90748",
"assets/assets/html/294aabb1": "9faa9f25eb41f662d7268f0f37a90748",
"assets/assets/html/37e5ad63": "9faa9f25eb41f662d7268f0f37a90748",
"assets/assets/html/ab6ddbb0": "9faa9f25eb41f662d7268f0f37a90748",
"assets/assets/html/b1de40cd": "9faa9f25eb41f662d7268f0f37a90748",
"assets/assets/html/d89ada6b": "9faa9f25eb41f662d7268f0f37a90748",
"assets/assets/html/fos_order_rule.html": "9faa9f25eb41f662d7268f0f37a90748",
"assets/assets/jpeg/1364ac31": "c843ceaff9f8077530dd1759a18ec305",
"assets/assets/jpeg/137a2821": "89b572f98054c3192aed6be300c388ce",
"assets/assets/jpeg/14ac78bf": "43f4d8c5e41215c69ef36f5e19c2cbb4",
"assets/assets/jpeg/1848820c": "89b572f98054c3192aed6be300c388ce",
"assets/assets/jpeg/1a3aa95d": "a3f42473bd693afe353f15c4c4573064",
"assets/assets/jpeg/1afb10de": "c2bcb6c5e722a35abc504c0439a14ecc",
"assets/assets/jpeg/1b52714e": "f022016aca14f27a69ee5383d97500f1",
"assets/assets/jpeg/1f153bd6": "89b572f98054c3192aed6be300c388ce",
"assets/assets/jpeg/2243cafb": "43f4d8c5e41215c69ef36f5e19c2cbb4",
"assets/assets/jpeg/227c6547": "4e1296d6469e316ff7ef409bb9be94b6",
"assets/assets/jpeg/22a31436": "e725d18cd943fdd636b19dd9df987acc",
"assets/assets/jpeg/25f575bc": "4e1296d6469e316ff7ef409bb9be94b6",
"assets/assets/jpeg/28d14114": "bc858d3815e1b94c90f7e588690ffc9d",
"assets/assets/jpeg/2d122c42": "f022016aca14f27a69ee5383d97500f1",
"assets/assets/jpeg/2e47456": "a66b270483618aa282bcc795381edbf9",
"assets/assets/jpeg/2ef1754c": "1613ea198bf9681ac5eece5357e0ed92",
"assets/assets/jpeg/32340108": "43f4d8c5e41215c69ef36f5e19c2cbb4",
"assets/assets/jpeg/39022f88": "86cc49437f34d3eef8a2084efccf0ca2",
"assets/assets/jpeg/3d6f1eea": "86cc49437f34d3eef8a2084efccf0ca2",
"assets/assets/jpeg/3efd0a05": "a66b270483618aa282bcc795381edbf9",
"assets/assets/jpeg/416ea7a4": "a3f42473bd693afe353f15c4c4573064",
"assets/assets/jpeg/43f16cd8": "89b572f98054c3192aed6be300c388ce",
"assets/assets/jpeg/441656cc": "e725d18cd943fdd636b19dd9df987acc",
"assets/assets/jpeg/46c398cf": "86cc49437f34d3eef8a2084efccf0ca2",
"assets/assets/jpeg/4852_20D_628C8123.dre": "c49a3263ad903703e1489bf2c42c86c6",
"assets/assets/jpeg/487d39d9": "bc858d3815e1b94c90f7e588690ffc9d",
"assets/assets/jpeg/4a2c38ee": "bc858d3815e1b94c90f7e588690ffc9d",
"assets/assets/jpeg/4ace5551": "86cc49437f34d3eef8a2084efccf0ca2",
"assets/assets/jpeg/4c0b2113": "b68ddaa554ffce230790cb6acb085dcd",
"assets/assets/jpeg/4c78bb5f": "a66b270483618aa282bcc795381edbf9",
"assets/assets/jpeg/4cdc936f": "43f4d8c5e41215c69ef36f5e19c2cbb4",
"assets/assets/jpeg/503f5a8c": "c49a3263ad903703e1489bf2c42c86c6",
"assets/assets/jpeg/5202e2f2": "e725d18cd943fdd636b19dd9df987acc",
"assets/assets/jpeg/53964f6c": "b68ddaa554ffce230790cb6acb085dcd",
"assets/assets/jpeg/5744e62": "5f820302c06dc55b135935e4185c0ef1",
"assets/assets/jpeg/59ba9876": "1613ea198bf9681ac5eece5357e0ed92",
"assets/assets/jpeg/5f93bad5": "47f429d3f561bce4bf50f67b623aaded",
"assets/assets/jpeg/604aed99": "89b572f98054c3192aed6be300c388ce",
"assets/assets/jpeg/643f175b": "2e3ff0940fab3175b27943b5e4b140e2",
"assets/assets/jpeg/6d07f116": "c843ceaff9f8077530dd1759a18ec305",
"assets/assets/jpeg/75ad389c": "4e1296d6469e316ff7ef409bb9be94b6",
"assets/assets/jpeg/7863248f": "4e1296d6469e316ff7ef409bb9be94b6",
"assets/assets/jpeg/7923b592": "a66b270483618aa282bcc795381edbf9",
"assets/assets/jpeg/7b58d129": "f022016aca14f27a69ee5383d97500f1",
"assets/assets/jpeg/7c78dbe6": "2e3ff0940fab3175b27943b5e4b140e2",
"assets/assets/jpeg/7d148a52": "bc858d3815e1b94c90f7e588690ffc9d",
"assets/assets/jpeg/7eb226ae": "bc858d3815e1b94c90f7e588690ffc9d",
"assets/assets/jpeg/82c166d3": "c49a3263ad903703e1489bf2c42c86c6",
"assets/assets/jpeg/8478dbb5": "c2bcb6c5e722a35abc504c0439a14ecc",
"assets/assets/jpeg/849f2b14": "0fa267d039c2aa64a5c06516dbd2a507",
"assets/assets/jpeg/8520542d": "6b848ae32a1bf9839391c9a6e91905ce",
"assets/assets/jpeg/863319fb": "86d5e798a1e65f2f460e8cf480aa1043",
"assets/assets/jpeg/8a1949fd": "86cc49437f34d3eef8a2084efccf0ca2",
"assets/assets/jpeg/8a9cc64b": "47f429d3f561bce4bf50f67b623aaded",
"assets/assets/jpeg/8c9605ce": "a66b270483618aa282bcc795381edbf9",
"assets/assets/jpeg/8ed016c2": "f022016aca14f27a69ee5383d97500f1",
"assets/assets/jpeg/9131184d": "43f4d8c5e41215c69ef36f5e19c2cbb4",
"assets/assets/jpeg/9772c618": "4e1296d6469e316ff7ef409bb9be94b6",
"assets/assets/jpeg/9c77cfa8": "0fa267d039c2aa64a5c06516dbd2a507",
"assets/assets/jpeg/9da9acc3": "c843ceaff9f8077530dd1759a18ec305",
"assets/assets/jpeg/a06bf5d8": "f022016aca14f27a69ee5383d97500f1",
"assets/assets/jpeg/a576699": "4e1296d6469e316ff7ef409bb9be94b6",
"assets/assets/jpeg/ab6a306d": "c2bcb6c5e722a35abc504c0439a14ecc",
"assets/assets/jpeg/ac086512": "0fa267d039c2aa64a5c06516dbd2a507",
"assets/assets/jpeg/ac85fc35": "1613ea198bf9681ac5eece5357e0ed92",
"assets/assets/jpeg/acc68092": "e71a64e26072fc1d6aebe56866036045",
"assets/assets/jpeg/adc25779": "c49a3263ad903703e1489bf2c42c86c6",
"assets/assets/jpeg/adc91829": "a66b270483618aa282bcc795381edbf9",
"assets/assets/jpeg/b219c9be": "e71a64e26072fc1d6aebe56866036045",
"assets/assets/jpeg/b2377380": "f022016aca14f27a69ee5383d97500f1",
"assets/assets/jpeg/b277c671": "2e3ff0940fab3175b27943b5e4b140e2",
"assets/assets/jpeg/b2dc77e2": "c843ceaff9f8077530dd1759a18ec305",
"assets/assets/jpeg/b302b9ef": "e725d18cd943fdd636b19dd9df987acc",
"assets/assets/jpeg/b6e6517a": "e71a64e26072fc1d6aebe56866036045",
"assets/assets/jpeg/background_0.jpeg": "0fa267d039c2aa64a5c06516dbd2a507",
"assets/assets/jpeg/background_1.jpeg": "c49a3263ad903703e1489bf2c42c86c6",
"assets/assets/jpeg/background_10.jpeg": "f022016aca14f27a69ee5383d97500f1",
"assets/assets/jpeg/background_11.jpeg": "c2bcb6c5e722a35abc504c0439a14ecc",
"assets/assets/jpeg/background_12.jpeg": "c843ceaff9f8077530dd1759a18ec305",
"assets/assets/jpeg/background_13.jpeg": "43f4d8c5e41215c69ef36f5e19c2cbb4",
"assets/assets/jpeg/background_14.jpeg": "4e1296d6469e316ff7ef409bb9be94b6",
"assets/assets/jpeg/background_15.jpeg": "bc858d3815e1b94c90f7e588690ffc9d",
"assets/assets/jpeg/background_16.jpeg": "2e3ff0940fab3175b27943b5e4b140e2",
"assets/assets/jpeg/background_17.jpeg": "47f429d3f561bce4bf50f67b623aaded",
"assets/assets/jpeg/background_18.jpeg": "b68ddaa554ffce230790cb6acb085dcd",
"assets/assets/jpeg/background_19.jpeg": "86cc49437f34d3eef8a2084efccf0ca2",
"assets/assets/jpeg/background_2.jpeg": "86d5e798a1e65f2f460e8cf480aa1043",
"assets/assets/jpeg/background_20.jpeg": "a3f42473bd693afe353f15c4c4573064",
"assets/assets/jpeg/background_21.jpeg": "a66b270483618aa282bcc795381edbf9",
"assets/assets/jpeg/background_3.jpeg": "6b848ae32a1bf9839391c9a6e91905ce",
"assets/assets/jpeg/background_4.jpeg": "e725d18cd943fdd636b19dd9df987acc",
"assets/assets/jpeg/background_5.jpeg": "1613ea198bf9681ac5eece5357e0ed92",
"assets/assets/jpeg/background_6.jpeg": "5f820302c06dc55b135935e4185c0ef1",
"assets/assets/jpeg/background_7.jpeg": "89b572f98054c3192aed6be300c388ce",
"assets/assets/jpeg/background_8.jpeg": "e71a64e26072fc1d6aebe56866036045",
"assets/assets/jpeg/background_9.jpeg": "25b1da52d7caa96d3966c4a3cfabf663",
"assets/assets/jpeg/bc3cabdc": "c2bcb6c5e722a35abc504c0439a14ecc",
"assets/assets/jpeg/bd726cfe": "2e3ff0940fab3175b27943b5e4b140e2",
"assets/assets/jpeg/be98526c": "e725d18cd943fdd636b19dd9df987acc",
"assets/assets/jpeg/bf477850": "b68ddaa554ffce230790cb6acb085dcd",
"assets/assets/jpeg/c8610dac": "86cc49437f34d3eef8a2084efccf0ca2",
"assets/assets/jpeg/c9c75317": "4e1296d6469e316ff7ef409bb9be94b6",
"assets/assets/jpeg/ca5ccbe7": "0fa267d039c2aa64a5c06516dbd2a507",
"assets/assets/jpeg/d07c0abd": "bc858d3815e1b94c90f7e588690ffc9d",
"assets/assets/jpeg/d4b09f31": "1613ea198bf9681ac5eece5357e0ed92",
"assets/assets/jpeg/d83bc027": "e725d18cd943fdd636b19dd9df987acc",
"assets/assets/jpeg/d86c0c37": "2e3ff0940fab3175b27943b5e4b140e2",
"assets/assets/jpeg/db7baafe": "86d5e798a1e65f2f460e8cf480aa1043",
"assets/assets/jpeg/dd63480f": "c49a3263ad903703e1489bf2c42c86c6",
"assets/assets/jpeg/deeee679": "4e1296d6469e316ff7ef409bb9be94b6",
"assets/assets/jpeg/df27580c": "43f4d8c5e41215c69ef36f5e19c2cbb4",
"assets/assets/jpeg/df41621a": "2e3ff0940fab3175b27943b5e4b140e2",
"assets/assets/jpeg/e3257a7": "b68ddaa554ffce230790cb6acb085dcd",
"assets/assets/jpeg/e53fc882": "6b848ae32a1bf9839391c9a6e91905ce",
"assets/assets/jpeg/e6664da2": "5f820302c06dc55b135935e4185c0ef1",
"assets/assets/jpeg/e9f409b5": "6b848ae32a1bf9839391c9a6e91905ce",
"assets/assets/jpeg/ea6ce77c": "0fa267d039c2aa64a5c06516dbd2a507",
"assets/assets/jpeg/ec664376": "2e3ff0940fab3175b27943b5e4b140e2",
"assets/assets/jpeg/ecbec628": "86cc49437f34d3eef8a2084efccf0ca2",
"assets/assets/jpeg/eda93838": "a3f42473bd693afe353f15c4c4573064",
"assets/assets/jpeg/f0bdd7dc": "c2bcb6c5e722a35abc504c0439a14ecc",
"assets/assets/jpeg/f0c1bfe4": "6b848ae32a1bf9839391c9a6e91905ce",
"assets/assets/jpeg/f0d3303e": "86cc49437f34d3eef8a2084efccf0ca2",
"assets/assets/jpeg/f934e45": "c843ceaff9f8077530dd1759a18ec305",
"assets/assets/jpeg/fb55b963": "bc858d3815e1b94c90f7e588690ffc9d",
"assets/assets/jpeg/fc2e4609": "5f820302c06dc55b135935e4185c0ef1",
"assets/assets/jpeg/fe766170": "1613ea198bf9681ac5eece5357e0ed92",
"assets/assets/jpeg/ffacbf1f": "5f820302c06dc55b135935e4185c0ef1",
"assets/assets/jpg/37a87aba": "f0a638031a66bbe549f9289df7d4d1cf",
"assets/assets/jpg/7362228": "f0a638031a66bbe549f9289df7d4d1cf",
"assets/assets/jpg/de147a6f": "f0a638031a66bbe549f9289df7d4d1cf",
"assets/assets/jpg/kindergarten.jpg": "f0a638031a66bbe549f9289df7d4d1cf",
"assets/assets/json/brs_locale_en_us.json": "79013e1a330fefffdd2426e30105a3dc",
"assets/assets/json/brs_locale_zh_cn.json": "c3c03b603caa056aa8ff6c5d6e475a9f",
"assets/assets/json/brs_locale_zh_hk.json": "97d113a848864fefb9c6c2b9dd8e33fe",
"assets/assets/json/domain.json": "ab9e0a6f7f6e72105b717744318eba50",
"assets/assets/json/fos_locale_en_us.json": "0847fe1f839493496ab9e75f6c14a46f",
"assets/assets/json/fos_locale_zh_cn.json": "47e1d102d1a84ad71008bbd3a2ebfc0c",
"assets/assets/json/fos_locale_zh_hk.json": "8016d9733fbc83457fd8965be2c5c24f",
"assets/assets/json/motto.json": "f1a57c6f12641786278d3b384914b691",
"assets/assets/json/mwb_locale_en_us.json": "45ec32892f7c7185a9545dcbff39f3c3",
"assets/assets/json/mwb_locale_zh_cn.json": "56d864659e1c5f07107c962aac0c2e28",
"assets/assets/json/mwb_locale_zh_hk.json": "725b18de3ff8644c74ad2ffa1efb2a4d",
"assets/assets/json/phone_number.json": "964f0438ae47321e38923ea83d08b4ef",
"assets/assets/md/fos_order_rule.md": "049db15002f65b7017597d6a482c3043",
"assets/assets/md/sample.md": "09f9bb49b2651cfbde124e654bce1209",
"assets/assets/mp3/2284280e": "607b5b3ab9b4766ab7c2108aade6cb90",
"assets/assets/mp3/39fbd4b1": "211768b1a0229dc931855a6cb94a0fc8",
"assets/assets/mp3/411b56": "461546a8a265206342f0ec6af38cf54c",
"assets/assets/mp3/52d5896e": "461546a8a265206342f0ec6af38cf54c",
"assets/assets/mp3/68b81f38": "211768b1a0229dc931855a6cb94a0fc8",
"assets/assets/mp3/695c7eef": "607b5b3ab9b4766ab7c2108aade6cb90",
"assets/assets/mp3/6ed83a22": "607b5b3ab9b4766ab7c2108aade6cb90",
"assets/assets/mp3/703fa49d": "461546a8a265206342f0ec6af38cf54c",
"assets/assets/mp3/7b675328": "607b5b3ab9b4766ab7c2108aade6cb90",
"assets/assets/mp3/c9073463": "461546a8a265206342f0ec6af38cf54c",
"assets/assets/mp3/cdc863b2": "211768b1a0229dc931855a6cb94a0fc8",
"assets/assets/mp3/d3956034": "461546a8a265206342f0ec6af38cf54c",
"assets/assets/mp3/Keys%2520Of%2520Moon%2520-%2520Blooming%2520Melody.mp3": "461546a8a265206342f0ec6af38cf54c",
"assets/assets/mp3/Keys%2520Of%2520Moon%2520-%2520Enchanted.mp3": "607b5b3ab9b4766ab7c2108aade6cb90",
"assets/assets/mp3/Keys%2520Of%2520Moon%2520-%2520Yugen.mp3": "211768b1a0229dc931855a6cb94a0fc8",
"assets/assets/png/1315ea76": "007cedfa7f1fa35f4ef1f00bc0278018",
"assets/assets/png/2dee6a41": "6b32750a9f43f7543ea1db3e319503a6",
"assets/assets/png/303efa18": "6b32750a9f43f7543ea1db3e319503a6",
"assets/assets/png/308001c9": "6b32750a9f43f7543ea1db3e319503a6",
"assets/assets/png/335f0bb1": "007cedfa7f1fa35f4ef1f00bc0278018",
"assets/assets/png/6e59b666": "007cedfa7f1fa35f4ef1f00bc0278018",
"assets/assets/png/70b779f7": "007cedfa7f1fa35f4ef1f00bc0278018",
"assets/assets/png/716b4251": "007cedfa7f1fa35f4ef1f00bc0278018",
"assets/assets/png/720d7b2b": "007cedfa7f1fa35f4ef1f00bc0278018",
"assets/assets/png/7e15adc3": "81abe832ddfc0eccb7d369c5aa3693f4",
"assets/assets/png/99d05b": "0837036a2fd701eec701a9db6166f1c9",
"assets/assets/png/a2ee1636": "81abe832ddfc0eccb7d369c5aa3693f4",
"assets/assets/png/b0ad3578": "6b32750a9f43f7543ea1db3e319503a6",
"assets/assets/png/b5e32236": "6b32750a9f43f7543ea1db3e319503a6",
"assets/assets/png/b6b14abd": "007cedfa7f1fa35f4ef1f00bc0278018",
"assets/assets/png/cfff78eb": "007cedfa7f1fa35f4ef1f00bc0278018",
"assets/assets/png/e2e7cd6d": "81abe832ddfc0eccb7d369c5aa3693f4",
"assets/assets/png/edf1bea": "0837036a2fd701eec701a9db6166f1c9",
"assets/assets/png/f15366b1": "81abe832ddfc0eccb7d369c5aa3693f4",
"assets/assets/png/fos_logo.png": "007cedfa7f1fa35f4ef1f00bc0278018",
"assets/assets/png/mwb_favicon_0.png": "6b32750a9f43f7543ea1db3e319503a6",
"assets/assets/png/mwb_favicon_1.png": "0837036a2fd701eec701a9db6166f1c9",
"assets/assets/png/no_image.png": "81abe832ddfc0eccb7d369c5aa3693f4",
"assets/FontManifest.json": "14cc791d91d8b182abc3f583bb6e5fdc",
"assets/fonts/MaterialIcons-Regular.otf": "1b97d61bc9c706f10b11b0cb4a03ddc5",
"assets/node_modules/jsqr/dist/jsQR.js": "24a9f1fe8467e1578412b8764bac9d84",
"assets/NOTICES": "08c928421b17bbdf114c8b7782edfb31",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_AMS-Regular.ttf": "657a5353a553777e270827bd1630e467",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Bold.ttf": "a9c8e437146ef63fcd6fae7cf65ca859",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Regular.ttf": "7ec92adfa4fe03eb8e9bfb60813df1fa",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Bold.ttf": "46b41c4de7a936d099575185a94855c4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Regular.ttf": "dede6f2c7dad4402fa205644391b3a94",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Bold.ttf": "9eef86c1f9efa78ab93d41a0551948f7",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-BoldItalic.ttf": "e3c361ea8d1c215805439ce0941a1c8d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Italic.ttf": "ac3b1882325add4f148f05db8cafd401",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Regular.ttf": "5a5766c715ee765aa1398997643f1589",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-BoldItalic.ttf": "946a26954ab7fbd7ea78df07795a6cbc",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-Italic.ttf": "a7732ecb5840a15be39e1eda377bc21d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Bold.ttf": "ad0a28f28f736cf4c121bcb0e719b88a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Italic.ttf": "d89b80e7bdd57d238eeaa80ed9a1013a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Regular.ttf": "b5f967ed9e4933f1c3165a12fe3436df",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Script-Regular.ttf": "55d2dcd4778875a53ff09320a85a5296",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size1-Regular.ttf": "1e6a3368d660edc3a2fbbe72edfeaa85",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size2-Regular.ttf": "959972785387fe35f7d47dbfb0385bc4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size3-Regular.ttf": "e87212c26bb86c21eb028aba2ac53ec3",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size4-Regular.ttf": "85554307b465da7eb785fd3ce52ad282",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Typewriter-Regular.ttf": "87f56927f1ba726ce0591955c8b3b42d",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Brands-Regular-400.otf": "b66a46c1150a91482991e85691044c22",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Free-Regular-400.otf": "a03d7ae50d2d2e00b33d40c6b114c1e9",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Free-Solid-900.otf": "e151d7a6f42f17e9ea335c91d07b3739",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "36e5e860173b05bcb074152a7beee4a0",
"canvaskit/canvaskit.wasm": "989996637efe372016fa18c627f5c6e9",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "b828e7b064d7fdf14fd4722a7743b5d4",
"canvaskit/chromium/canvaskit.wasm": "567c0835df12ce9e7dd9a9dec6ba7009",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "7253dc992ccad7e3bf5b765f0112f737",
"canvaskit/skwasm.wasm": "579b9679cca9de279aaf133f81abf1de",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "9513c4c9560e5f92b2ecfb6336095a15",
"canvaskit/skwasm_heavy.wasm": "7bec619779a37a51e34f7761aec99e27",
"deploy.html": "a5cf6500e2c3857b3fb785e06e770d1b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "35408b1be0f5de68cc5d1c5175d717ed",
"flutter_bootstrap.js": "625fb493c90db28f201b27096dcec7bd",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "328b6766b986cde6e21cd4efbb0277f0",
"/": "328b6766b986cde6e21cd4efbb0277f0",
"main.dart.js": "c70e53bd8ef7288376008ef5abf82ef4",
"manifest.json": "ba5c7f54abd807b20aa52b239bb3adb5",
"version.json": "9692e6a2dac4ad01af0fd4a3db0756bd"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
