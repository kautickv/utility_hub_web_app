import React from 'react';
import Typography from "@mui/material/Typography";
import Box from "@mui/material/Box";
import { BarChart, Bar, CartesianGrid, XAxis, YAxis, Tooltip } from 'recharts';

function SlackChannel({ channel, messages }) {
    const [showGraph, setShowGraph] = React.useState(false);

    const handleClick = () => {
        setShowGraph(!showGraph);
    };

    const getDayHour = (timestamp) => {
        const date = new Date(timestamp * 1000);
        const day = date.getDate();
        const month = date.getMonth() + 1;
        const year = date.getFullYear();
        const hour = date.getHours();
        return `${year}-${month}-${day} ${hour}:00`;
    }

    const aggregateData = (messages) => {
        let hourlyData = {};
        messages.forEach(message => {
            const dayHour = getDayHour(message.ts);
            if (!hourlyData[dayHour]) {
                hourlyData[dayHour] = 1;
            } else {
                hourlyData[dayHour]++;
            }
        });
        return Object.keys(hourlyData).map(dayHour => ({
            name: dayHour,
            count: hourlyData[dayHour]
        }));
    };

    const data = aggregateData(messages);

    return (
        <Box sx={{ mt: 2, mb: 2 }} onClick={handleClick}>
            <Typography variant="h6">{channel}</Typography>
            <Typography variant="body1">Number of messages: {messages.length}</Typography>
            {showGraph && (
                <BarChart width={500} height={300} data={data}>
                    <Bar dataKey="count" fill="#8884d8" activeOpacity={0} />
                    <CartesianGrid stroke="#ccc" />
                    <XAxis dataKey="name" />
                    <YAxis />
                    <Tooltip />
                </BarChart>
            )}
        </Box>
    );
}

export default SlackChannel;
