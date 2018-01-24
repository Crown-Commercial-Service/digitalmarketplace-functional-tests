{
  addressable = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mpn7sbjl477h56gmxsjqb89r5s3w7vx5af994ssgc3iamvgzgvs";
      type = "gem";
    };
    version = "2.4.0";
  };
  builder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
      type = "gem";
    };
    version = "3.2.2";
  };
  capybara = {
    dependencies = ["addressable" "mime-types" "nokogiri" "rack" "rack-test" "xpath"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dxab3nkdivdm9a2gw0a9giibgskrljnz095hq5xkwl41b24vbgn";
      type = "gem";
    };
    version = "2.10.1";
  };
  capybara-screenshot = {
    dependencies = ["capybara" "launchy"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xy79lf3rwn3602r4hqm9s8a03bhlf6hzwdi6345dzrkmhwwj2ij";
      type = "gem";
    };
    version = "1.0.14";
  };
  childprocess = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1is253wm9k2s325nfryjnzdqv9flq8bm4y2076mhdrncxamrh7r2";
      type = "gem";
    };
    version = "0.5.9";
  };
  cliver = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "096f4rj7virwvqxhkavy0v55rax10r4jqf8cymbvn4n631948xc7";
      type = "gem";
    };
    version = "0.3.2";
  };
  cucumber = {
    dependencies = ["builder" "cucumber-core" "cucumber-wire" "diff-lcs" "gherkin" "multi_json" "multi_test"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k4j31a93r0zhvyq2mm2k8irppbvkzbsg44r3mf023959v18fzih";
      type = "gem";
    };
    version = "2.4.0";
  };
  cucumber-core = {
    dependencies = ["gherkin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qj2fsqvp94nggnikbnrfvnmzr1pl6ifmdsxj69kdw1kkab30jjr";
      type = "gem";
    };
    version = "1.5.0";
  };
  cucumber-wire = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09ymvqb0sbw2if1nxg8rcj33sf0va88ancq5nmp8g01dfwzwma2f";
      type = "gem";
    };
    version = "0.0.1";
  };
  diff-lcs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
      type = "gem";
    };
    version = "1.2.5";
  };
  domain_name = {
    dependencies = ["unf"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rg7gvp45xmb5qz8ydp7ivw05hhplh6k7mbawrpvkysl2c77w5xx";
      type = "gem";
    };
    version = "0.5.20160826";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkcrmxqr0vb1y4rwliclwlj2ajsi4ddpdx2gvzjy0xbkk5iqzfp";
      type = "gem";
    };
    version = "1.9.14";
  };
  gherkin = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ripjv97hg746xszx9isal8z8vrlb98asc2rdxl291b3hr6pj0pr";
      type = "gem";
    };
    version = "4.0.0";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
      type = "gem";
    };
    version = "1.0.3";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lhinj9vj7mw59jqid0bjn2hlfcnq02bnvsx9iv81nl2han603s0";
      type = "gem";
    };
    version = "2.0.2";
  };
  jwt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "124zz1142bi2if7hl5pcrcamwchv4icyr5kaal9m2q6wqbdl6aw4";
      type = "gem";
    };
    version = "1.5.6";
  };
  launchy = {
    dependencies = ["addressable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190lfbiy1vwxhbgn4nl4dcbzxvm049jwc158r2x7kq3g5khjrxa2";
      type = "gem";
    };
    version = "2.4.3";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0087z9kbnlqhci7fxh9f6il63hj1k02icq2rs0c6cppmqchr753m";
      type = "gem";
    };
    version = "3.1";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04my3746hwa4yvbx1ranhfaqkgf6vavi1kyijjnw8w3dy37vqhkm";
      type = "gem";
    };
    version = "3.2016.0521";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13d32jjadpjj6d2wdhkfpsmy68zjx90p49bgf8f7nkpz86r1fr11";
      type = "gem";
    };
    version = "2.3.0";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wpc23ls6v2xbk3l1qncsbz16npvmw8p0b38l8czdzri18mp51xk";
      type = "gem";
    };
    version = "1.12.1";
  };
  multi_test = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sx356q81plr67hg16jfwz9hcqvnk03bd9n75pmdw8pfxjfy1yxd";
      type = "gem";
    };
    version = "0.1.2";
  };
  netrc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "105xh2zkr8nsyfaj2izaisarpnkrrl9000y3nyflg9cbzrfxv021";
      type = "gem";
    };
    version = "1.8.1";
  };
  notifications-ruby-client = {
    dependencies = ["jwt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z4pawvms2xqsn64x0ixs7q76bdnqsflwp2kn776z7m43ww14msi";
      type = "gem";
    };
    version = "2.2.0";
  };
  parallel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qv2yj4sxr36ga6xdxvbq9h05hn10bwcbkqv6j6q1fiixhsdnnzd";
      type = "gem";
    };
    version = "1.12.0";
  };
  parallel_tests = {
    dependencies = ["parallel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fg7l97wwb3d92p89vmky83ngwfcf8408fdcv2nazghcglwph84x";
      type = "gem";
    };
    version = "2.15.0";
  };
  phantomjs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y8pbbyq9dirxb7igkb2s5limz2895qmr41c09fjhx6k6fxcz4mk";
      type = "gem";
    };
    version = "2.1.1.0";
  };
  poltergeist = {
    dependencies = ["capybara" "cliver" "websocket-driver"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "098zgqhhphazxsikrj5mpsrij0l726wig26nn04bmm4r7n0zi5yl";
      type = "gem";
    };
    version = "1.11.0";
  };
  power_assert = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fpc9fxkr1pwk46v8v2sbcsqjaj7m2a1w8piz6w89mm93z6ak6zq";
      type = "gem";
    };
    version = "0.3.1";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "053bqbrxr5gjw5k3rrmh6i35s83kgdycxv292lid072vpwrq1xv1";
      type = "gem";
    };
    version = "2.0.1";
  };
  rack-test = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h6x5jq24makgv2fq5qqgjlrk74dxfy62jif9blk43llw8ib2q7z";
      type = "gem";
    };
    version = "0.6.3";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cnjmbcyhm4hacpjn337mg1pnaw6hj09f74clwgh6znx8wam9xla";
      type = "gem";
    };
    version = "11.3.0";
  };
  report_builder = {
    dependencies = ["builder" "json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bwbly3i50qdh272gvy0qff0741cykx44kapm0m2cy55wrdn3hpm";
      type = "gem";
    };
    version = "0.1.4";
  };
  rest-client = {
    dependencies = ["http-cookie" "mime-types" "netrc"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v2jp2ilpb2rm97yknxcnay9lfagcm4k82pfsmmcm9v290xm1ib7";
      type = "gem";
    };
    version = "2.0.0";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16g3mmih999f0b6vcz2c3qsc7ks5zy4lj1rzjh8hf6wk531nvc6s";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nacs062qbr98fx6czf1vwppn1js956nv2c8vfwj6i65axdfs46i";
      type = "gem";
    };
    version = "3.5.4";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bbqfrb1x8gmwf8x2xhhwvvlhwbbafq4isbvlibxi6jk602f09gs";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nl3ksivh9wwrjjd47z5dggrwx40v6gpb3a0gzbp1gs06a5dmk24";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-support = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10vf3k3d472y573mag2kzfsfrf6rv355s13kadnpryk8d36yq5r0";
      type = "gem";
    };
    version = "3.5.0";
  };
  rubyzip = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06js4gznzgh8ac2ldvmjcmg9v1vg9llm357yckkpylaj6z456zqz";
      type = "gem";
    };
    version = "1.2.1";
  };
  selenium-webdriver = {
    dependencies = ["childprocess" "rubyzip" "websocket"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "063fbypf0sq3jijjz4zvjjy5pahpyvx0xjwj11cpbzq1ksd6jf55";
      type = "gem";
    };
    version = "3.0.0";
  };
  test-unit = {
    dependencies = ["power_assert"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c6grgvwapy6vxkbpmflf9f7xlpxi4ck99mw4jlimpryp8lrnnah";
      type = "gem";
    };
    version = "3.2.1";
  };
  unf = {
    dependencies = ["unf_ext"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04d13bp6lyg695x94whjwsmzc2ms72d94vx861nx1y40k3817yp8";
      type = "gem";
    };
    version = "0.0.7.2";
  };
  websocket = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s8c24pys61wmg7frv9jzqss5i41z1nhz7g1rb4ll4pwxbrakvf0";
      type = "gem";
    };
    version = "1.2.3";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m37q24mxykvixcj8sv0jz7y2a88spysxg5rp4zf4p1q7mbblshy";
      type = "gem";
    };
    version = "0.6.4";
  };
  websocket-extensions = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07qnsafl6203a2zclxl20hy4jq11c471cgvd0bj5r9fx1qqw06br";
      type = "gem";
    };
    version = "0.1.2";
  };
  xpath = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04kcr127l34p7221z13blyl0dvh0bmxwx326j72idayri36a394w";
      type = "gem";
    };
    version = "2.0.0";
  };
}