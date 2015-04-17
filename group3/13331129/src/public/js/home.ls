insertToHomeworksTable = (docs, grade) !->
    $ '#homeworksTable' .find 'tr' .remove!
    for doc in docs
        if grade is 0
            $ '#homeworksTable' .append "<tr>
                                                                        <td>
                                                                            <a href = #{doc.url}>#{doc.name}</a>
                                                                        </td>
                                                                        <td></td>
                                                                    </tr>"
        else
            if doc.grade != undefined
                $ '#homeworksTable' .append "<tr>
                                                                        <td name=#{doc._id}>
                                                                            <a href = #{doc.url}>#{doc.name}</a>
                                                                        </td>
                                                                        <td contenteditable>#{doc.grade}</td>
                                                                    </tr>"
            else
                $ '#homeworksTable' .append "<tr>
                                                                        <td name=#{doc._id}>
                                                                            <a href = #{doc.url}>#{doc.name}</a>
                                                                        </td>
                                                                        <td contenteditable></td>
                                                                    </tr>"                
    if grade is 1
        $ '#homeworksTable' .append "<tr><td></td><td><button id='gradeBt' type='submit' class='btn btn-default'>submit</button><td></tr>"

insertToAssignmentsTable = (doc) !->
    $ '#assignmentsTable' .append "<tr>
                                                                    <td name=#{doc._id}>
                                                                        #{doc.title}
                                                                    </td>
                                                                    <td>#{doc.description}</td>
                                                                    <td>#{doc.date}</td>
                                                                    <td>
                                                                        <button class = 'btn btn-default check'> check </button>\n
                                                                        <button class = 'btn btn-default modift'> modify </button>\n
                                                                        <button class = 'btn btn-default delete'> delete </button>
                                                                    </td>
                                                                </tr>"

$ !->	
    $ '.input-group.date' .datepicker!
    $ document .on 'click', '.check', !->
        assignment = $ @ .parent! .siblings! .eq 0 .attr 'name'
        $ .ajax({
            type: "POST",
            url: "/getHomeworks",
            data: {assignment: assignment}
            dataType: "json"
            success: (response) !->
                insertToHomeworksTable(response.docs, response.grade)
        })

    $ document .on 'click', '.delete', !->
        assignment = $ @ .parent! .siblings! .eq 0 .attr 'name'
        that__ = @
        $ .ajax({
            type: "POST",
            url: "/delete",
            data: {assignment: assignment}
            success: (docs) !->
                $ that__ .parent! .parent! .remove!
        })

    $ '.upLoadForm' .submit ->
         that__ = @
         options = {
            success: (response)!-> 
                if response is 'timeout'
                    alert response
                $ that__ .parent! .siblings! .eq 3 .find " a" .text response.name
                $ that__ .parent! .siblings! .eq 3 .find "a" .attr 'href' response.path
         }
         $ @ .ajaxSubmit options
         return false

    $ '#assignmentForm' .submit ->
         options = {
            success: (doc)!->
                insertToAssignmentsTable doc
            error: (response) !->
         }
         $ @ .ajaxSubmit options
         return false

    $ document .on 'click', '#gradeBt', !->
        tmp = $ '#homeworksTable' .children!
        items = []
        for i from 0 to tmp.length - 2
            t = new Object!
            t.id = $ tmp[i] .children! .eq 0 .attr 'name'
            t.grade = $ tmp[i] .children! .eq 1 .text!
            Jtext = JSON.stringify t
            items[i] = Jtext
        $ .ajax({
            type: "POST",
            url: "/grade",
            data: {items: items}
            success: (docs) !->
                console.log "success"
        })              

    $ document .on 'click', '.modify', !->
        assignment = $ @ .parent! .siblings! .eq 0 .attr 'name'
        title = $ @ .parent! .siblings! .eq 0 .text!
        description = $ @ .parent! .siblings! .eq 1 .text!
        date = $ @ .parent! .siblings! .eq 2 .text!
        that__ = @
        $ .ajax({
            type: "POST",
            url: "/modify",
            data: {assignment: assignment, title: title, description:description, date:date}
            success: (docs) !->
                console.log "success"
        })      



 