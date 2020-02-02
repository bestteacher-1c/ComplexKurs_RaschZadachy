
Процедура ОбработкаПроведения(Отказ, Режим)

    ЗаполнитьНаборЗаписей_ОсновныеНачисления();
	Движения.ОсновныеНачисления.Записать();
	
	//РассчитатьРесурсы_ОсновныеНачисления();
	
	//@skip-warning
	Расчет.РассчитатьРесурсы_ОсновныеНачисления(Движения.ОсновныеНачисления);
	//@skip-warning
	Расчет.ЗаполнитьНаборЗаписей_ВзаиморасчетыСРаботниками(Движения.ВзаиморасчетыСРаботниками);
	
КонецПроцедуры


Процедура ЗаполнитьНаборЗаписей_ОсновныеНачисления()
	
	Движение = Движения.ОсновныеНачисления.Добавить();
	
	Движение.Сторно = Ложь;
	
	Движение.ВидРасчета = ПланыВидовРасчета.ОсновныеНачисления.Больничный;
	
	Движение.ПериодДействияНачало = ДатаНачала;
	Движение.ПериодДействияКонец = КонецДня(ДатаОкончания);
	
	Движение.ПериодРегистрации = ПериодРегистрации;
	
	ПервоеЧислоМесяцаЗаболел = НачалоМесяца(ДатаНачала);
	
	Движение.БазовыйПериодНачало = ДобавитьМесяц(ПервоеЧислоМесяцаЗаболел, -3);
	Движение.БазовыйПериодКонец = ПервоеЧислоМесяцаЗаболел - 1;
	
	Движение.ФизическоеЛицо = ФизическоеЛицо;
	Движение.Подразделение = Подразделение;
	Движение.Должность = Должность;
	
	Движение.Результат = 0;
	Движение.ОтработаноДней = 0;
	
	//@skip-warning
	Движение.Размер = Серверный.ПолучитьПроцентВыплатыЧислом(ПроцентВыплаты);
	Движение.ГрафикРаботы = Справочники.ВидыГрафиковРаботы.КалендарныеДни;

КонецПроцедуры


Процедура РассчитатьРесурсы_ОсновныеНачисления()

	НаборЗаписей = Движения.ОсновныеНачисления;

	Менеджер = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Менеджер;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОсновныеНачисления.НомерСтроки КАК НомерСтроки,
	|	ОсновныеНачисления.ВидРасчета КАК ВидРасчета,
	|	ОсновныеНачисления.ПериодРегистрации КАК ПериодРегистрации,
	|	ОсновныеНачисления.Регистратор КАК Регистратор,
	|	ОсновныеНачисления.ПериодДействия КАК ПериодДействия,
	|	ОсновныеНачисления.ПериодДействияНачало КАК ПериодДействияНачало,
	|	ОсновныеНачисления.ПериодДействияКонец КАК ПериодДействияКонец,
	|	ОсновныеНачисления.БазовыйПериодНачало КАК БазовыйПериодНачало,
	|	ОсновныеНачисления.БазовыйПериодКонец КАК БазовыйПериодКонец,
	|	ОсновныеНачисления.Активность КАК Активность,
	|	ОсновныеНачисления.Сторно КАК Сторно,
	|	ОсновныеНачисления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ОсновныеНачисления.Подразделение КАК Подразделение,
	|	ОсновныеНачисления.Должность КАК Должность,
	|	ОсновныеНачисления.Результат КАК Результат,
	|	ОсновныеНачисления.ОтработаноДней КАК ОтработаноДней,
	|	ОсновныеНачисления.Размер КАК Размер,
	|	ОсновныеНачисления.ГрафикРаботы КАК ГрафикРаботы
	|ПОМЕСТИТЬ ВТДвижения
	|ИЗ
	|	РегистрРасчета.ОсновныеНачисления КАК ОсновныеНачисления
	|ГДЕ
	|	ОсновныеНачисления.Регистратор = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТДвижения.ВидРасчета
	|ПОМЕСТИТЬ ВТВидыРасчетаДокумента
	|ИЗ
	|	ВТДвижения КАК ВТДвижения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВидыРасчетаДокумента.ВидРасчета,
	|	ОсновныеНачисленияВедущиеВидыРасчета.ВидРасчета КАК ВедущийВидРасчета
	|ПОМЕСТИТЬ ВТВедущиеВидыРасчета
	|ИЗ
	|	ВТВидыРасчетаДокумента КАК ВТВидыРасчетаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланВидовРасчета.ОсновныеНачисления.ВедущиеВидыРасчета КАК ОсновныеНачисленияВедущиеВидыРасчета
	|		ПО ВТВидыРасчетаДокумента.ВидРасчета = ОсновныеНачисленияВедущиеВидыРасчета.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТВедущиеВидыРасчета.ВидРасчета,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТВидыРасчетаДокумента.ВидРасчета) КАК Приоритет
	|ПОМЕСТИТЬ ВТПриоритетыВидовРасчета
	|ИЗ
	|	ВТВедущиеВидыРасчета КАК ВТВедущиеВидыРасчета
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТВидыРасчетаДокумента КАК ВТВидыРасчетаДокумента
	|		ПО ВТВедущиеВидыРасчета.ВедущийВидРасчета = ВТВидыРасчетаДокумента.ВидРасчета
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТВедущиеВидыРасчета.ВидРасчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТДвижения.НомерСтроки КАК НомерСтроки,
	|	ВТДвижения.ВидРасчета КАК ВидРасчета,
	|	ВТДвижения.ПериодРегистрации КАК ПериодРегистрации,
	|	ВТДвижения.Регистратор КАК Регистратор,
	|	ВТДвижения.ПериодДействия КАК ПериодДействия,
	|	ВТДвижения.ПериодДействияНачало КАК ПериодДействияНачало,
	|	ВТДвижения.ПериодДействияКонец КАК ПериодДействияКонец,
	|	ВТДвижения.БазовыйПериодНачало КАК БазовыйПериодНачало,
	|	ВТДвижения.БазовыйПериодКонец КАК БазовыйПериодКонец,
	|	ВТДвижения.Активность КАК Активность,
	|	ВТДвижения.Сторно КАК Сторно,
	|	ВТДвижения.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВТДвижения.Подразделение КАК Подразделение,
	|	ВТДвижения.Должность КАК Должность,
	|	ВТДвижения.Результат КАК Результат,
	|	ВТДвижения.ОтработаноДней КАК ОтработаноДней,
	|	ВТДвижения.Размер КАК Размер,
	|	ВТДвижения.ГрафикРаботы КАК ГрафикРаботы,
	|	ВТПриоритетыВидовРасчета.Приоритет КАК Приоритет
	|ПОМЕСТИТЬ ВТНаборЗаписей
	|ИЗ
	|	ВТДвижения КАК ВТДвижения
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПриоритетыВидовРасчета КАК ВТПриоритетыВидовРасчета
	|		ПО ВТДвижения.ВидРасчета = ВТПриоритетыВидовРасчета.ВидРасчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТНаборЗаписей.НомерСтроки КАК НомерСтроки,
	|	ВТНаборЗаписей.Приоритет КАК Приоритет,
	|	ВТНаборЗаписей.ВидРасчета.СпособРасчета КАК СпособРасчета,
	|	ВТНаборЗаписей.ВидРасчета.Формула КАК Формула,
	|	ВТНаборЗаписей.ВидРасчета.ЗачетОтработанногоВремени КАК ЗачетОтработанногоВремени
	|ИЗ
	|	ВТНаборЗаписей КАК ВТНаборЗаписей
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Приоритет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТДвижения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТВидыРасчетаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТВедущиеВидыРасчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТПриоритетыВидовРасчета";
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаПриоритет = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	//Внешний цикл по Приоритету
	Пока ВыборкаПриоритет.Следующий() Цикл
		
		//Запрос для получения базы и данных графика для записей с текущим приоритетом 
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Менеджер;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВТНаборЗаписей.НомерСтроки КАК НомерСтроки,
		|	ВТНаборЗаписей.ФизическоеЛицо.СреднийЗаработокЗаДень КАК СреднийЗаработокЗаДень
		|ПОМЕСТИТЬ ВТЗаписиДляРасчета
		|ИЗ
		|	ВТНаборЗаписей КАК ВТНаборЗаписей
		|ГДЕ
		|	ВТНаборЗаписей.Приоритет = &Приоритет
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОсновныеНачисленияДанныеГрафика.НомерСтроки КАК НомерСтроки,
		|	ЕСТЬNULL(ОсновныеНачисленияДанныеГрафика.ЗначениеДниФактическийПериодДействия, 0) КАК ЗначениеДниФактическийПериодДействия
		|ПОМЕСТИТЬ ВТДанныеГрафика
		|ИЗ
		|	РегистрРасчета.ОсновныеНачисления.ДанныеГрафика(
		|			Регистратор = &Регистратор
		|				И ВидРасчета.ТребуетДанныеГрафика = ИСТИНА
		|				И НомерСтроки В
		|					(ВЫБРАТЬ
		|						ВТЗаписиДляРасчета.НомерСтроки
		|					ИЗ
		|						ВТЗаписиДляРасчета КАК ВТЗаписиДляРасчета)) КАК ОсновныеНачисленияДанныеГрафика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ОсновныеНачисленияБазаОсновныеНачисления.НомерСтроки КАК НомерСтроки,
		|	ОсновныеНачисленияБазаОсновныеНачисления.РезультатБаза КАК РезультатБаза,
		|	ОсновныеНачисленияБазаОсновныеНачисления.ОтработаноДнейБаза КАК ОтработаноДнейБаза
		|ПОМЕСТИТЬ ВТБазаВОсновныхНачислениях
		|ИЗ
		|	РегистрРасчета.ОсновныеНачисления.БазаОсновныеНачисления(
		|			&Измерения_ОсновныеНачисления,
		|			&Измерения_ОсновныеНачисления,
		|			,
		|			Регистратор = &Регистратор
		|				И ВидРасчета.ТребуетСбораБазы
		|				И НомерСтроки В
		|					(ВЫБРАТЬ
		|						ВТЗаписиДляРасчета.НомерСтроки
		|					ИЗ
		|						ВТЗаписиДляРасчета КАК ВТЗаписиДляРасчета)) КАК ОсновныеНачисленияБазаОсновныеНачисления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТЗаписиДляРасчета.НомерСтроки КАК НомерСтроки,
		|	ЕСТЬNULL(ВТДанныеГрафика.ЗначениеДниФактическийПериодДействия, 0) КАК ЗначениеДниФактическийПериодДействия,
		|	ЕСТЬNULL(ВТБазаВОсновныхНачислениях.РезультатБаза, 0) КАК РезультатБаза,
		|	ЕСТЬNULL(ВТБазаВОсновныхНачислениях.ОтработаноДнейБаза, 0) КАК ОтработаноДнейБаза
		|ИЗ
		|	ВТЗаписиДляРасчета КАК ВТЗаписиДляРасчета
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеГрафика КАК ВТДанныеГрафика
		|		ПО (ВТДанныеГрафика.НомерСтроки = ВТЗаписиДляРасчета.НомерСтроки)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБазаВОсновныхНачислениях КАК ВТБазаВОсновныхНачислениях
		|		ПО (ВТБазаВОсновныхНачислениях.НомерСтроки = ВТЗаписиДляРасчета.НомерСтроки)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТЗаписиДляРасчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВТДанныеГрафика";
		
		Запрос.УстановитьПараметр("Регистратор", Ссылка);
		Запрос.УстановитьПараметр("Приоритет", ВыборкаПриоритет.Приоритет);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		//Выборка с данными для записей текущей категории
		Выборка_ДанныеГрафика_База = РезультатЗапроса.Выбрать();
		
		Пока Выборка_ДанныеГрафика_База.Следующий() Цикл
			
			//Запись = НаборЗаписей.Получить(Выборка_ДанныеГрафика_База.НомерСтроки - 1);
			//
			//СреднийЗаработок = Выборка_ДанныеГрафика_База.СреднийЗаработокЗаДень;			
			//ПроцентВыплатыЧислом = Запись.Размер;
			//
			//ДнейБолел = Выборка_ДанныеГрафика_База.ЗначениеДниФактическийПериодДействия;
			//
			//Запись.Результат = СреднийЗаработок
			//*ДнейБолел * ПроцентВыплатыЧислом / 100;
			//
			
			
			Запись = НаборЗаписей.Получить(Выборка_ДанныеГрафика_База.НомерСтроки - 1);
			
			ОтработалЗаТриМесяца = Выборка_ДанныеГрафика_База.ОтработаноДнейБаза;
			
			ДнейБолел = Выборка_ДанныеГрафика_База.ЗначениеДниФактическийПериодДействия;
			
			Если ОтработалЗаТриМесяца = 0 Тогда
				
				//У нас социальное государство. Ст. 7 Конституции РФ.
				//Вы не работали до заболевания и нет базы для расчета среднего заработка.
				//Значит больничный платиться из расчтета по МРОТ (для примера взят МРОТ на 01.05.2016 г.)
				
				Запись.Результат = 7800 /Выборка_ДанныеГрафика_База.ДниПериодДействия * ДнейБолел; 
				
				//Кстати. Ст. 29 Каждому гарантируется свобода мысли и слова.
				
				//Ст. 31. Граждане Российской Федерации имеют право собираться мирно,
				//без оружия, проводить собрания, митинги и демонстрации, шествия и пикетирование.
				
				Продолжить;
			КонецЕсли;
			
			ЗаработалЗаТриМесяца = Выборка_ДанныеГрафика_База.РезультатБаза;
			
			ПроцентВыплаты = Запись.Размер;
			
			Запись.Результат = (ЗаработалЗаТриМесяца / ОтработалЗаТриМесяца)
			*ДнейБолел * ПроцентВыплаты / 100;
			
		КонецЦикла;
		
		НаборЗаписей.Записать(,Истина);
		
	КонецЦикла;
		
	
КонецПроцедуры


