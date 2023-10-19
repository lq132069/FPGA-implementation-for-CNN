/*
该模块首先将coe文件中的数据存储到ROM中。
每给一个地址，会在下个时钟上升沿输出相应的数据
*/

module data_test_ROM (
    input clk,
    input rst,
    input start_flag,
    output reg [address_width*data_width-1:0] data
  );

  parameter address_width = 900; // 设置地址位宽，足够存储900个data_test数据
  parameter data_width = 16;    // 设置数据位宽

  reg [data_width-1:0] rom_data [0:address_width-1];

  // 在这里加载数据
  initial
  begin
    $readmemh("data/data_test16.coe", rom_data);
  end

  // 访问ROM并输出数据

  reg [7:0] address; // 内部地址变量
  always @(posedge clk or posedge rst)
  begin
    if (rst)
    begin
      data <= 1600'b0; // 在复位时将输出清零
    end
    else if(start_flag)
    begin
      // 从ROM中读取数据并拼接
      data <=
      {
       rom_data[899], rom_data[898], rom_data[897], rom_data[896],
       rom_data[895], rom_data[894], rom_data[893], rom_data[892],
       rom_data[891], rom_data[890], rom_data[889], rom_data[888],
       rom_data[887], rom_data[886], rom_data[885], rom_data[884],
       rom_data[883], rom_data[882], rom_data[881], rom_data[880],
       rom_data[879], rom_data[878], rom_data[877], rom_data[876],
       rom_data[875], rom_data[874], rom_data[873], rom_data[872],
       rom_data[871], rom_data[870], rom_data[869], rom_data[868],
       rom_data[867], rom_data[866], rom_data[865], rom_data[864],
       rom_data[863], rom_data[862], rom_data[861], rom_data[860],
       rom_data[859], rom_data[858], rom_data[857], rom_data[856],
       rom_data[855], rom_data[854], rom_data[853], rom_data[852],
       rom_data[851], rom_data[850], rom_data[849], rom_data[848],
       rom_data[847], rom_data[846], rom_data[845], rom_data[844],
       rom_data[843], rom_data[842], rom_data[841], rom_data[840],
       rom_data[839], rom_data[838], rom_data[837], rom_data[836],
       rom_data[835], rom_data[834], rom_data[833], rom_data[832],
       rom_data[831], rom_data[830], rom_data[829], rom_data[828],
       rom_data[827], rom_data[826], rom_data[825], rom_data[824],
       rom_data[823], rom_data[822], rom_data[821], rom_data[820],
       rom_data[819], rom_data[818], rom_data[817], rom_data[816],
       rom_data[815], rom_data[814], rom_data[813], rom_data[812],
       rom_data[811], rom_data[810], rom_data[809], rom_data[808],
       rom_data[807], rom_data[806], rom_data[805], rom_data[804],
       rom_data[803], rom_data[802], rom_data[801], rom_data[800],
       rom_data[799], rom_data[798], rom_data[797], rom_data[796],
       rom_data[795], rom_data[794], rom_data[793], rom_data[792],
       rom_data[791], rom_data[790], rom_data[789], rom_data[788],
       rom_data[787], rom_data[786], rom_data[785], rom_data[784],
       rom_data[783], rom_data[782], rom_data[781], rom_data[780],
       rom_data[779], rom_data[778], rom_data[777], rom_data[776],
       rom_data[775], rom_data[774], rom_data[773], rom_data[772],
       rom_data[771], rom_data[770], rom_data[769], rom_data[768],
       rom_data[767], rom_data[766], rom_data[765], rom_data[764],
       rom_data[763], rom_data[762], rom_data[761], rom_data[760],
       rom_data[759], rom_data[758], rom_data[757], rom_data[756],
       rom_data[755], rom_data[754], rom_data[753], rom_data[752],
       rom_data[751], rom_data[750], rom_data[749], rom_data[748],
       rom_data[747], rom_data[746], rom_data[745], rom_data[744],
       rom_data[743], rom_data[742], rom_data[741], rom_data[740],
       rom_data[739], rom_data[738], rom_data[737], rom_data[736],
       rom_data[735], rom_data[734], rom_data[733], rom_data[732],
       rom_data[731], rom_data[730], rom_data[729], rom_data[728],
       rom_data[727], rom_data[726], rom_data[725], rom_data[724],
       rom_data[723], rom_data[722], rom_data[721], rom_data[720],
       rom_data[719], rom_data[718], rom_data[717], rom_data[716],
       rom_data[715], rom_data[714], rom_data[713], rom_data[712],
       rom_data[711], rom_data[710], rom_data[709], rom_data[708],
       rom_data[707], rom_data[706], rom_data[705], rom_data[704],
       rom_data[703], rom_data[702], rom_data[701], rom_data[700],
       rom_data[699], rom_data[698], rom_data[697], rom_data[696],
       rom_data[695], rom_data[694], rom_data[693], rom_data[692],
       rom_data[691], rom_data[690], rom_data[689], rom_data[688],
       rom_data[687], rom_data[686], rom_data[685], rom_data[684],
       rom_data[683], rom_data[682], rom_data[681], rom_data[680],
       rom_data[679], rom_data[678], rom_data[677], rom_data[676],
       rom_data[675], rom_data[674], rom_data[673], rom_data[672],
       rom_data[671], rom_data[670], rom_data[669], rom_data[668],
       rom_data[667], rom_data[666], rom_data[665], rom_data[664],
       rom_data[663], rom_data[662], rom_data[661], rom_data[660],
       rom_data[659], rom_data[658], rom_data[657], rom_data[656],
       rom_data[655], rom_data[654], rom_data[653], rom_data[652],
       rom_data[651], rom_data[650], rom_data[649], rom_data[648],
       rom_data[647], rom_data[646], rom_data[645], rom_data[644],
       rom_data[643], rom_data[642], rom_data[641], rom_data[640],
       rom_data[639], rom_data[638], rom_data[637], rom_data[636],
       rom_data[635], rom_data[634], rom_data[633], rom_data[632],
       rom_data[631], rom_data[630], rom_data[629], rom_data[628],
       rom_data[627], rom_data[626], rom_data[625], rom_data[624],
       rom_data[623], rom_data[622], rom_data[621], rom_data[620],
       rom_data[619], rom_data[618], rom_data[617], rom_data[616],
       rom_data[615], rom_data[614], rom_data[613], rom_data[612],
       rom_data[611], rom_data[610], rom_data[609], rom_data[608],
       rom_data[607], rom_data[606], rom_data[605], rom_data[604],
       rom_data[603], rom_data[602], rom_data[601], rom_data[600],
       rom_data[599], rom_data[598], rom_data[597], rom_data[596],
       rom_data[595], rom_data[594], rom_data[593], rom_data[592],
       rom_data[591], rom_data[590], rom_data[589], rom_data[588],
       rom_data[587], rom_data[586], rom_data[585], rom_data[584],
       rom_data[583], rom_data[582], rom_data[581], rom_data[580],
       rom_data[579], rom_data[578], rom_data[577], rom_data[576],
       rom_data[575], rom_data[574], rom_data[573], rom_data[572],
       rom_data[571], rom_data[570], rom_data[569], rom_data[568],
       rom_data[567], rom_data[566], rom_data[565], rom_data[564],
       rom_data[563], rom_data[562], rom_data[561], rom_data[560],
       rom_data[559], rom_data[558], rom_data[557], rom_data[556],
       rom_data[555], rom_data[554], rom_data[553], rom_data[552],
       rom_data[551], rom_data[550], rom_data[549], rom_data[548],
       rom_data[547], rom_data[546], rom_data[545], rom_data[544],
       rom_data[543], rom_data[542], rom_data[541], rom_data[540],
       rom_data[539], rom_data[538], rom_data[537], rom_data[536],
       rom_data[535], rom_data[534], rom_data[533], rom_data[532],
       rom_data[531], rom_data[530], rom_data[529], rom_data[528],
       rom_data[527], rom_data[526], rom_data[525], rom_data[524],
       rom_data[523], rom_data[522], rom_data[521], rom_data[520],
       rom_data[519], rom_data[518], rom_data[517], rom_data[516],
       rom_data[515], rom_data[514], rom_data[513], rom_data[512],
       rom_data[511], rom_data[510], rom_data[509], rom_data[508],
       rom_data[507], rom_data[506], rom_data[505], rom_data[504],
       rom_data[503], rom_data[502], rom_data[501], rom_data[500],
       rom_data[499], rom_data[498], rom_data[497], rom_data[496],
       rom_data[495], rom_data[494], rom_data[493], rom_data[492],
       rom_data[491], rom_data[490], rom_data[489], rom_data[488],
       rom_data[487], rom_data[486], rom_data[485], rom_data[484],
       rom_data[483], rom_data[482], rom_data[481], rom_data[480],
       rom_data[479], rom_data[478], rom_data[477], rom_data[476],
       rom_data[475], rom_data[474], rom_data[473], rom_data[472],
       rom_data[471], rom_data[470], rom_data[469], rom_data[468],
       rom_data[467], rom_data[466], rom_data[465], rom_data[464],
       rom_data[463], rom_data[462], rom_data[461], rom_data[460],
       rom_data[459], rom_data[458], rom_data[457], rom_data[456],
       rom_data[455], rom_data[454], rom_data[453], rom_data[452],
       rom_data[451], rom_data[450], rom_data[449], rom_data[448],
       rom_data[447], rom_data[446], rom_data[445], rom_data[444],
       rom_data[443], rom_data[442], rom_data[441], rom_data[440],
       rom_data[439], rom_data[438], rom_data[437], rom_data[436],
       rom_data[435], rom_data[434], rom_data[433], rom_data[432],
       rom_data[431], rom_data[430], rom_data[429], rom_data[428],
       rom_data[427], rom_data[426], rom_data[425], rom_data[424],
       rom_data[423], rom_data[422], rom_data[421], rom_data[420],
       rom_data[419], rom_data[418], rom_data[417], rom_data[416],
       rom_data[415], rom_data[414], rom_data[413], rom_data[412],
       rom_data[411], rom_data[410], rom_data[409], rom_data[408],
       rom_data[407], rom_data[406], rom_data[405], rom_data[404],
       rom_data[403], rom_data[402], rom_data[401], rom_data[400],
       rom_data[399], rom_data[398], rom_data[397], rom_data[396],
       rom_data[395], rom_data[394], rom_data[393], rom_data[392],
       rom_data[391], rom_data[390], rom_data[389], rom_data[388],
       rom_data[387], rom_data[386], rom_data[385], rom_data[384],
       rom_data[383], rom_data[382], rom_data[381], rom_data[380],
       rom_data[379], rom_data[378], rom_data[377], rom_data[376],
       rom_data[375], rom_data[374], rom_data[373], rom_data[372],
       rom_data[371], rom_data[370], rom_data[369], rom_data[368],
       rom_data[367], rom_data[366], rom_data[365], rom_data[364],
       rom_data[363], rom_data[362], rom_data[361], rom_data[360],
       rom_data[359], rom_data[358], rom_data[357], rom_data[356],
       rom_data[355], rom_data[354], rom_data[353], rom_data[352],
       rom_data[351], rom_data[350], rom_data[349], rom_data[348],
       rom_data[347], rom_data[346], rom_data[345], rom_data[344],
       rom_data[343], rom_data[342], rom_data[341], rom_data[340],
       rom_data[339], rom_data[338], rom_data[337], rom_data[336],
       rom_data[335], rom_data[334], rom_data[333], rom_data[332],
       rom_data[331], rom_data[330], rom_data[329], rom_data[328],
       rom_data[327], rom_data[326], rom_data[325], rom_data[324],
       rom_data[323], rom_data[322], rom_data[321], rom_data[320],
       rom_data[319], rom_data[318], rom_data[317], rom_data[316],
       rom_data[315], rom_data[314], rom_data[313], rom_data[312],
       rom_data[311], rom_data[310], rom_data[309], rom_data[308],
       rom_data[307], rom_data[306], rom_data[305], rom_data[304],
       rom_data[303], rom_data[302], rom_data[301], rom_data[300],
       rom_data[299], rom_data[298], rom_data[297], rom_data[296],
       rom_data[295], rom_data[294], rom_data[293], rom_data[292],
       rom_data[291], rom_data[290], rom_data[289], rom_data[288],
       rom_data[287], rom_data[286], rom_data[285], rom_data[284],
       rom_data[283], rom_data[282], rom_data[281], rom_data[280],
       rom_data[279], rom_data[278], rom_data[277], rom_data[276],
       rom_data[275], rom_data[274], rom_data[273], rom_data[272],
       rom_data[271], rom_data[270], rom_data[269], rom_data[268],
       rom_data[267], rom_data[266], rom_data[265], rom_data[264],
       rom_data[263], rom_data[262], rom_data[261], rom_data[260],
       rom_data[259], rom_data[258], rom_data[257], rom_data[256],
       rom_data[255], rom_data[254], rom_data[253], rom_data[252],
       rom_data[251], rom_data[250], rom_data[249], rom_data[248],
       rom_data[247], rom_data[246], rom_data[245], rom_data[244],
       rom_data[243], rom_data[242], rom_data[241], rom_data[240],
       rom_data[239], rom_data[238], rom_data[237], rom_data[236],
       rom_data[235], rom_data[234], rom_data[233], rom_data[232],
       rom_data[231], rom_data[230], rom_data[229], rom_data[228],
       rom_data[227], rom_data[226], rom_data[225], rom_data[224],
       rom_data[223], rom_data[222], rom_data[221], rom_data[220],
       rom_data[219], rom_data[218], rom_data[217], rom_data[216],
       rom_data[215], rom_data[214], rom_data[213], rom_data[212],
       rom_data[211], rom_data[210], rom_data[209], rom_data[208],
       rom_data[207], rom_data[206], rom_data[205], rom_data[204],
       rom_data[203], rom_data[202], rom_data[201], rom_data[200],
       rom_data[199], rom_data[198], rom_data[197], rom_data[196],
       rom_data[195], rom_data[194], rom_data[193], rom_data[192],
       rom_data[191], rom_data[190], rom_data[189], rom_data[188],
       rom_data[187], rom_data[186], rom_data[185], rom_data[184],
       rom_data[183], rom_data[182], rom_data[181], rom_data[180],
       rom_data[179], rom_data[178], rom_data[177], rom_data[176],
       rom_data[175], rom_data[174], rom_data[173], rom_data[172],
       rom_data[171], rom_data[170], rom_data[169], rom_data[168],
       rom_data[167], rom_data[166], rom_data[165], rom_data[164],
       rom_data[163], rom_data[162], rom_data[161], rom_data[160],
       rom_data[159], rom_data[158], rom_data[157], rom_data[156],
       rom_data[155], rom_data[154], rom_data[153], rom_data[152],
       rom_data[151], rom_data[150], rom_data[149], rom_data[148],
       rom_data[147], rom_data[146], rom_data[145], rom_data[144],
       rom_data[143], rom_data[142], rom_data[141], rom_data[140],
       rom_data[139], rom_data[138], rom_data[137], rom_data[136],
       rom_data[135], rom_data[134], rom_data[133], rom_data[132],
       rom_data[131], rom_data[130], rom_data[129], rom_data[128],
       rom_data[127], rom_data[126], rom_data[125], rom_data[124],
       rom_data[123], rom_data[122], rom_data[121], rom_data[120],
       rom_data[119], rom_data[118], rom_data[117], rom_data[116],
       rom_data[115], rom_data[114], rom_data[113], rom_data[112],
       rom_data[111], rom_data[110], rom_data[109], rom_data[108],
       rom_data[107], rom_data[106], rom_data[105], rom_data[104],
       rom_data[103], rom_data[102], rom_data[101], rom_data[100],
       rom_data[99], rom_data[98], rom_data[97], rom_data[96],
       rom_data[95], rom_data[94], rom_data[93], rom_data[92],
       rom_data[91], rom_data[90], rom_data[89], rom_data[88],
       rom_data[87], rom_data[86], rom_data[85], rom_data[84],
       rom_data[83], rom_data[82], rom_data[81], rom_data[80],
       rom_data[79], rom_data[78], rom_data[77], rom_data[76],
       rom_data[75], rom_data[74], rom_data[73], rom_data[72],
       rom_data[71], rom_data[70], rom_data[69], rom_data[68],
       rom_data[67], rom_data[66], rom_data[65], rom_data[64],
       rom_data[63], rom_data[62], rom_data[61], rom_data[60],
       rom_data[59], rom_data[58], rom_data[57], rom_data[56],
       rom_data[55], rom_data[54], rom_data[53], rom_data[52],
       rom_data[51], rom_data[50], rom_data[49], rom_data[48],
       rom_data[47], rom_data[46], rom_data[45], rom_data[44],
       rom_data[43], rom_data[42], rom_data[41], rom_data[40],
       rom_data[39], rom_data[38], rom_data[37], rom_data[36],
       rom_data[35], rom_data[34], rom_data[33], rom_data[32],
       rom_data[31], rom_data[30], rom_data[29], rom_data[28],
       rom_data[27], rom_data[26], rom_data[25], rom_data[24],
       rom_data[23], rom_data[22], rom_data[21], rom_data[20],
       rom_data[19], rom_data[18], rom_data[17], rom_data[16],
       rom_data[15], rom_data[14], rom_data[13], rom_data[12],
       rom_data[11], rom_data[10], rom_data[9], rom_data[8],
       rom_data[7], rom_data[6], rom_data[5], rom_data[4],
       rom_data[3], rom_data[2], rom_data[1], rom_data[0]};
    end
  end

endmodule



