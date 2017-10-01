#!/usr/bin/python3

import os
import collections
import datetime

repo_folder = os.path.realpath(os.path.abspath(os.path.join(
    os.path.normpath(os.path.join(os.getcwd(), *(["../.."] * 1))))))
repo_name = os.path.basename(repo_folder)
spices_type = repo_name.split('-')[-1].title()


def TableTitle(title, subtitle="", subsubtitle=""):
    table_title = '<h1>' + title + '</h1>\n'
    table_title += '<p>\n'
    if subtitle == "":
        table_title += '  <b>' + spices_type + '</b>\n'
    else:
        table_title += '  <a href="../tables/README.md">' + spices_type + '</a> &#187; <b>' + subtitle + '</b>\n'
    if subsubtitle != "":
        table_title += '</br><b><sub>' + subsubtitle + '</sub></b>\n'
    table_title += '</p>\n\n'
    return table_title

def TableHead(class2name):
    table_head =  '<table>\n'
    table_head += '  <thead>\n'
    table_head += '    <tr>\n'
    for class_id in class2name:
        table_head += '      <th>\n'
        table_head += '        <a href="#" id="' + class_id + '">' + class2name[class_id] + '</a>\n'
        table_head += '      </th>\n'
    table_head += '    </tr>\n'
    table_head += '  </thead>\n'
    table_head += '  <tbody>\n'
    return table_head

def TableContent(class2value):
    table_content = '    <tr>\n'
    for class_id in class2value:
        table_content += '      <td class="' + class_id +'" data-value="' + class2value[class_id][0] + '">\n'
        table_content += '        ' + class2value[class_id][1] + '\n'
        table_content += '      </td>\n'
    table_content += '    </tr>\n'
    return table_content

def TableBodyClose():
    table_body_ending =  '  </tbody>\n'
    return table_body_ending

def TableClose():
    table_ending =  '</table>\n\n'
    now = str(datetime.datetime.utcnow().strftime("%Y-%m-%d, %H:%M"))
    table_ending += '<p><sup>This translation status table was last updated on ' + now + ' UTC.</sup></p>\n'
    return table_ending

def Str2HtmlHref(link, text):
    return '<a href="' + link + '">' + text + '</a>'

def Value2HtmlProgressImage(percentage):
    return '<img src="http://progressed.io/bar/' + percentage + '" alt="' + percentage + '%" />'

def Progess(untranslated, translated):
    return str(int(round(100 * float(translated - untranslated)/float(translated))))


class Main():

    def __init__(self):
        #% store translation info in matrix/dict
        translation_uuid_matrix = collections.defaultdict(dict) # [UUID][ID]
        translation_lang_matrix = collections.defaultdict(dict) # [ID][UUID]

        #% get known lang_id and lang_name from LINGUAS-ID
        id2name = {}
        with open(os.path.join(repo_folder, ".translation-tables", "status-py-scripts", "LINGUAS-ID"), "r") as linguas_id_file:
            for linguas_id_line in linguas_id_file:
                lang_id = linguas_id_line.split(':')[0]
                lang_name = linguas_id_line.split(':')[1].rstrip()
                id2name[lang_id] = lang_name

        #% create directory to store updated po files
        hidden_po_dir = os.path.join(repo_folder, ".translation-tables", "po")
        try:
            os.makedirs(hidden_po_dir)
        except OSError:
            pass

        #% populate translation matrix
        try:
            #% for UUID
            for uuid in os.listdir(repo_folder):
                #% ignore files and hidden dirs
                if uuid.startswith('.') or not os.path.isdir(os.path.join(repo_folder, uuid)):
                    continue

                #% ignore spices without po dir
                spices_po_dir = os.path.join(repo_folder, uuid, "files", uuid, "po")
                if not os.path.isdir(spices_po_dir):
                    continue

                #% get pot file directory
                pot_file_path = None
                for file in os.listdir(spices_po_dir):
                    if file.endswith(".pot"):
                        pot_file_path = os.path.join(spices_po_dir, file)

                #% count number of translatable Strings in pot file
                pot_length = int(os.popen('grep "^msgid " ' + pot_file_path + ' | wc -l').read()) - 1
                translation_uuid_matrix[uuid]["length"] = pot_length
                translation_lang_matrix["length"][uuid] = pot_length
                #% init translation matrix
                for known_id in id2name:
                    translation_uuid_matrix[uuid][known_id] = pot_length
                    translation_lang_matrix[known_id][uuid] = pot_length

                #% # create uuid dir in hidden_po_dir
                updated_spices_po_dir = os.path.join(hidden_po_dir, uuid)
                try:
                    os.makedirs(updated_spices_po_dir)
                except OSError:
                    pass
                #% # creating po files in hidden po dir
                for po_file in os.listdir(spices_po_dir):
                    if po_file.endswith('.po'):
                        current_id = po_file.split('.')[0]
                        if current_id in id2name:
                            po_file_path = os.path.join(spices_po_dir, po_file)
                            updated_po_file_path = os.path.join(updated_spices_po_dir, po_file)
                            untranslated_po_file_path = os.path.join(updated_spices_po_dir, '_' + po_file)
                            try:
                                os.remove(untranslated_po_file_path)
                            except OSError:
                                pass
                            #% update po from pot
                            os.system('msgmerge --silent --output-file=' + updated_po_file_path + ' ' + po_file_path + ' ' + pot_file_path)
                            # remove fuzzy and extract untranslated
                            os.system('msgattrib --clear-fuzzy --empty ' + updated_po_file_path + ' | msgattrib --untranslated --output-file=' + untranslated_po_file_path)

                            #% if no untranslated exist
                            if not os.path.exists(untranslated_po_file_path):
                                translation_uuid_matrix[uuid][current_id] = 0
                                translation_lang_matrix[current_id][uuid] = 0
                            else:
                                # count untranslated Strings
                                untranslated_length = int(os.popen('grep "^msgid " ' + untranslated_po_file_path + ' | wc -l').read()) - 1
                                translation_uuid_matrix[uuid][current_id] = untranslated_length
                                translation_lang_matrix[current_id][uuid] = untranslated_length

                        else:
                            print("Unknown locale: " + uuid + "/po/" + po_file)


        finally:
            #% create directory for tables
            tables_dir = os.path.join(repo_folder, ".translation-tables", "tables")
            try:
                os.makedirs(tables_dir)
            except OSError:
                pass

            #% TABLE: UUID.md
            for uuid in translation_lang_matrix["length"]:
                with open(os.path.join(tables_dir, uuid + '.md'), "w") as uuid_table_file:
                    #% TABLE TITLE
                    uuid_table_file.write(TableTitle("Translation status", uuid))
                    #% TABLE HEAD
                    thead_class2name = collections.OrderedDict()
                    thead_class2name["language"] = "Language"
                    thead_class2name["idpo"] = "ID.po"
                    thead_class2name["status"] = "Status"
                    thead_class2name["untranslated"] = "Untranslated"
                    uuid_table_file.write(TableHead(thead_class2name))

                    uuid_pot_length = translation_uuid_matrix[uuid]["length"]
                    for locale in sorted(id2name):
                        if not os.path.isfile(os.path.join(hidden_po_dir, uuid, locale + '.po')):
                            continue
                        # TABLE CONTENT
                        tdata_class2value = collections.OrderedDict()

                        tdata_value = id2name[locale]
                        tdata_content = Str2HtmlHref('../tables/' + locale + '.md', tdata_value)
                        tdata_class2value["language"] = [tdata_value, tdata_content]

                        tdata_value = locale
                        tdata_content = Str2HtmlHref('../po/' + uuid + '/' + locale + '.po', tdata_value + '.po')
                        tdata_class2value["idpo"] = [tdata_value, tdata_content]

                        untranslated_length = translation_uuid_matrix[uuid][locale]
                        tdata_value = Progess(untranslated_length, uuid_pot_length)
                        tdata_content = Value2HtmlProgressImage(tdata_value)
                        tdata_class2value["status"] = [tdata_value, tdata_content]

                        tdata_value = str(untranslated_length)
                        if tdata_value == "0":
                            tdata_content = tdata_value
                        else:
                            tdata_content = Str2HtmlHref('../po/' + uuid + '/_' + locale + '.po', tdata_value)
                        tdata_class2value["untranslated"] = [tdata_value, tdata_content]

                        uuid_table_file.write(TableContent(tdata_class2value))

                    uuid_table_file.write(TableBodyClose())
                    uuid_table_file.write(TableClose())
                uuid_table_file.close()


            #% README TABLE: README.md
            with open(os.path.join(tables_dir, 'README.md'), "w") as language_table_file:
                #% README TABLE TITLE
                language_table_file.write(TableTitle("Translation status by language"))
                #% README TABLE HEAD
                reamde_thead_class2name = collections.OrderedDict()
                reamde_thead_class2name["language"] = "Language"
                reamde_thead_class2name["localeid"] = "ID"
                reamde_thead_class2name["status"] = "Status"
                reamde_thead_class2name["untranslated"] = "Untranslated"
                language_table_file.write(TableHead(reamde_thead_class2name))


                #% LOCALE TABLE: LOCALE.md
                num_of_templates = str(len(translation_lang_matrix["length"]))
                for locale in sorted(id2name):
                    length_sum = 0
                    untranslated_sum = 0
                    locale_table_file_path = os.path.join(tables_dir, locale + '.md')
                    with open(locale_table_file_path, "w") as locale_table_file:
                        #% LOCALE TABLE TITLE
                        locale_table_file.write(TableTitle("Translatable templates", id2name[locale] + '(' + locale + ')', '1 &#8594; ' + num_of_templates + ' templates'))
                        #% LOCALE TABLE HEAD
                        thead_class2name = collections.OrderedDict()
                        thead_class2name["uuid"] = "UUID"
                        thead_class2name["length"] = "Length"
                        thead_class2name["status"] = "Status"
                        thead_class2name["untranslated"] = "Untranslated"
                        locale_table_file.write(TableHead(thead_class2name))
                        for uuid in sorted(translation_lang_matrix[locale]):
                            # LOCALE TABLE CONTENT
                            tdata_class2value = collections.OrderedDict()

                            tdata_value = uuid
                            tdata_content = Str2HtmlHref('../tables/' + uuid + '.md', tdata_value)
                            tdata_class2value["uuid"] = [tdata_value, tdata_content]

                            uuid_pot_length = translation_uuid_matrix[uuid]["length"]
                            length_sum += uuid_pot_length
                            tdata_value = str(uuid_pot_length)
                            tdata_content = tdata_value
                            tdata_class2value["length"] = [tdata_value, tdata_content]

                            untranslated_length = translation_uuid_matrix[uuid][locale]
                            untranslated_sum += untranslated_length
                            tdata_value = Progess(untranslated_length, uuid_pot_length)
                            tdata_content = Value2HtmlProgressImage(tdata_value)
                            tdata_class2value["status"] = [tdata_value, tdata_content]

                            tdata_value = str(untranslated_length)
                            if untranslated_length == 0 or untranslated_length == uuid_pot_length:
                                tdata_content = tdata_value
                            else:
                                tdata_content = Str2HtmlHref('../po/' + uuid + '/_' + locale + '.po', tdata_value)
                            tdata_class2value["untranslated"] = [tdata_value, tdata_content]

                            locale_table_file.write(TableContent(tdata_class2value))

                        # README TABLE CONTENT
                        readme_tdata_class2value = collections.OrderedDict()

                        readme_tdata_value = id2name[locale]
                        readme_tdata_content = Str2HtmlHref(locale + '.md', readme_tdata_value)
                        readme_tdata_class2value["language"] = [readme_tdata_value, readme_tdata_content]

                        readme_tdata_value = locale
                        readme_tdata_content = readme_tdata_value
                        readme_tdata_class2value["localeid"] = [readme_tdata_value, readme_tdata_content]

                        # LOCALE TABLE FOOT
                        locale_table_file.write('  <tfoot>\n')

                        tdata_value = 'Overall statistics:'
                        tdata_content = '<b>' + tdata_value + '</b>'
                        tdata_class2value["uuid"] = [tdata_value, tdata_content]

                        tdata_value = str(length_sum)
                        tdata_content = '<b>' + tdata_value + '</b>'
                        tdata_class2value["length"] = [tdata_value, tdata_content]

                        tdata_value = Progess(untranslated_sum, length_sum)
                        tdata_content = Value2HtmlProgressImage(tdata_value)
                        tdata_class2value["status"] = [tdata_value, tdata_content]
                        readme_tdata_class2value["status"] = [tdata_value, tdata_content]

                        tdata_value = str(untranslated_sum)
                        tdata_content = '<b>' + tdata_value + '</b>'
                        tdata_class2value["untranslated"] = [tdata_value, tdata_content]
                        readme_tdata_class2value["untranslated"] = [tdata_value, tdata_content]

                        locale_table_file.write(TableContent(tdata_class2value))
                        locale_table_file.write('  </tfoot>\n')
                        locale_table_file.write(TableClose())

                    locale_table_file.close()


                    #% write README TABLE content (but only if translations for locale exists)
                    if length_sum == untranslated_sum:
                        try:
                            os.remove(locale_table_file_path)
                        except OSError:
                            pass
                    else:
                        language_table_file.write(TableContent(readme_tdata_class2value))

                #% README TABLE close
                language_table_file.write(TableBodyClose())
                language_table_file.write(TableClose())
            language_table_file.close()


if __name__ == "__main__":
    print("Updating tables ...")
    Main()
